// =======
// Copyright 2018 Heidelpay GmbH
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =========


import UIKit

/// UITextFieldDelegate that can handle grouping
class GroupingTextFieldDelegate: ChainingTextFieldDelegate {

    /// the grouping style to use
    private var _groupingMode: GroupingStyle
    
    /// the grouping style that is used by this delegate
    var groupingMode: GroupingStyle {
        return _groupingMode
    }
    
    /// the grouping separator that is used
    let groupingSeparator: String
    
    init(groupingSeparator: String, groupingMode: GroupingStyle) {
        self.groupingSeparator = groupingSeparator
        self._groupingMode = groupingMode
    }
    
    /// Handle text change and automatically insert of remove grouping separators
    /// Also validates if a change is allowed based on the current groupingStyle (because of a length limitation)
    /// and optionally blocks input accordingly
    public override func textField(_ textField: UITextField,
                                   shouldChangeCharactersIn range: NSRange,
                                   replacementString string: String) -> Bool {
        var text = ""
        if let currentText = textField.text {
            text = currentText
        }
        
        var changedText = (text as NSString).replacingCharacters(in: range, with: string)
        
        if chainedDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) == false {
            return false
        }
        
        if String.heidelpay_hasRemovedSingleCharacterFrom(originalText: text, changedText: changedText) {
            // removing a single character
            if text.hasSuffix(groupingSeparator) {
                changedText.removeLast()
                textField.text = changedText
                textField.sendActions(for: .valueChanged)
                return false
            }
        } else if String.heidelpay_hasAddedSingleCharacterTo(originalText: text, changedText: changedText) {
            let change = groupingMode.handleAddingSingleCharacterToText(changedText,
                                                                        withGroupingSeparator: groupingSeparator)
            if let updatedText = change.updatedText {
                textField.text = updatedText
                textField.sendActions(for: .valueChanged)
            }
            return change.shouldAllowChange
            
        } else { // A big change is performed
            textField.text = groupingMode.groupedString(changedText as String, separator: groupingSeparator)
            textField.sendActions(for: .valueChanged)
            NotificationCenter.default.post(name: UITextField.textDidChangeNotification,
                                            object: textField,
                                            userInfo: [:])
            textField.heidelpay_moveCursorToEndOfText()
            
            return false
        }
        return true
    }
    
    func groupedText(_ text: String?) -> String? {
        let condensedString = String.heidelpay_nonOptionalCondensedString(text, groupingSeparator: groupingSeparator)
        return groupingMode.groupedString(condensedString, separator: groupingSeparator)
    }
}

extension UITextField {
    
    /// Asynchronously moves the cursor in the textfield to the end of the document
    func heidelpay_moveCursorToEndOfText() {
        DispatchQueue.main.async { [weak self] in
            if let endOfDocument = self?.endOfDocument {
                self?.selectedTextRange = self?.textRange(from: endOfDocument, to: endOfDocument)
            }
        }
    }
}

extension GroupingStyle {
    /// Handles adding a single character
    /// Parameter text: The new modified text
    /// Parameter withGroupingSeparator: The grouping separator to use for this text field
    /// Returns: Tuple with an optional updated text and a flag whether the change should be allowed
    func handleAddingSingleCharacterToText(_ text: String,
                                           withGroupingSeparator groupingSeparator: String)
        -> (updatedText: String?, shouldAllowChange: Bool) {
            
        switch self {
        case .fixedGroupsAndVariableLength(groupSize: let groupSize, maximumLength: let maximumLength):
            return handleAddingSingleCharacter(text,
                                               withGroupingSeparator: groupingSeparator,
                                               groupSize: groupSize,
                                               maximumLength: maximumLength)
        case .variableGroups(groupSizes: let groupSizes, maximumLength: let maximumLength):
            return handleAddingSingleCharacter(text,
                                               withGroupingSeparator: groupingSeparator,
                                               groupSizes: groupSizes,
                                               maximumLength: maximumLength)
        }
    }
    
    /// Handles adding a single character for a grouping style with a fixed group size
    /// Parameter text: The new modified text
    /// Parameter withGroupingSeparator: The grouping separator to use for this text field
    /// Parameter groupSize: The groupsize
    /// Parameter maximumLength: The maximum length of the text
    /// Returns: Tuple with an optional updated text and a flag whether the change should be allowed
    private func handleAddingSingleCharacter(_ text: String,
                                             withGroupingSeparator groupingSeparator: String,
                                             groupSize: Int,
                                             maximumLength: Int)
        -> (updatedText: String?, shouldAllowChange: Bool) {
            
        let normalizedChangedText = String.heidelpay_nonEmptyCondensedString(text,
                                                                             groupingSeparator: groupingSeparator)
        
        if let normalizedChangedText = normalizedChangedText, normalizedChangedText.count > maximumLength {
            return (nil, false)
        }
        
        let components = text.components(separatedBy: groupingSeparator)
        
        if let lastComponent = components.last {
            if lastComponent.count == groupSize {
                if let normalizedChangedText = normalizedChangedText {
                    if normalizedChangedText.count == maximumLength {
                        return (nil, true)
                    }
                }
                return ("\(text)\(groupingSeparator)", false)
            }
        }
        
        return (nil, true)
    }
    
    /// Handles adding a single character with variable group sizes
    /// Parameter text: The new modified text
    /// Parameter withGroupingSeparator: The grouping separator to use for this text field
    /// Parameter groupSizes: The group sizes
    /// Parameter maximumLength: The maximum length of the text
    /// Returns: Tuple with an optional updated text and a flag whether the change should be allowed
    private func handleAddingSingleCharacter(_ text: String,
                                             withGroupingSeparator groupingSeparator: String,
                                             groupSizes: [Int],
                                             maximumLength: Int)
        -> (updatedText: String?, shouldAllowChange: Bool) {
            
        let normalizedChangedText = String.heidelpay_nonEmptyCondensedString(text,
                                                                             groupingSeparator: groupingSeparator)
        
        if let normalizedChangedText = normalizedChangedText, normalizedChangedText.count > maximumLength {
            return (nil, false)
        }
        
        let components = text.components(separatedBy: groupingSeparator)
        
        if let lastComponent = components.last {
            let groupSize = groupSizes[components.count - 1]
            if lastComponent.count == groupSize {
                if let normalizedChangedText = normalizedChangedText,
                    normalizedChangedText.count == maximumLength {
                    return (nil, true)
                }
                return ("\(text)\(groupingSeparator)", false)
            }
        }
        
        return (nil, true)
    }
}
