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

// swiftlint:disable cyclomatic_complexity

/// Custom Delegate for IBAN Input
class IBANTextFieldDelegate: GroupingTextFieldDelegate {

    /// The allowed alpha characters in an IBAN
    private static let heidelpayAllowedIbanAlphaCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ "
    
    /// The allowed number characters in an IBAN
    private static let heidelpayAllowedIbanNumberCharacters = "01234567890 "
    
    convenience init() {
        self.init(groupingSeparator: " ", groupingMode: .fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 34))
    }
    
    /// Handles text change; Automatically valides input, uses grouping behaviour of superclass and
    /// appropriately switches keyboard type based on IBAN validation
    override public func textField(_ textField: UITextField,
                                   shouldChangeCharactersIn range: NSRange,
                                   replacementString string: String) -> Bool {

        let originalText = String.heidelpay_nonOptionalString(textField.text)
        let changedText = (originalText as NSString).replacingCharacters(in: range, with: string)
        
        var hasModifiedKeyboardType = false
        if changedText.count < 2 {
            if textField.keyboardType != .alphabet {
                textField.keyboardType = .alphabet
                hasModifiedKeyboardType = true
            }
        } else if changedText.count == 2 {
            //if IBAN that supports only numbers
            if textField.keyboardType != .numberPad {
                textField.keyboardType = .numberPad
                hasModifiedKeyboardType = true
            }
            // else
            //if textField.keyboardType =! .alphabet {
            //textField.keyboardType = .alphabet
            //hasModifiedKeyboardType = true
            //}
        }
        
        if changedText.count > 2 {
            //let substring = String(changedText[changedText.index(changedText.startIndex, offsetBy: 2)...])
            // if IBAN supports only numbers -> check if string only contains numbers;
            // if not -> return false; otherwise check if it contains only allowed iban characters
            for index in 0..<changedText.count {
                let characterIndex = changedText.index(changedText.startIndex, offsetBy: index)
                let character = String(changedText[characterIndex]).uppercased()
                if index < 2 {
                    if IBANTextFieldDelegate.heidelpayAllowedIbanAlphaCharacters.contains(character) == false {
                        return false
                    }
                } else {
                    // if IBAN that supports only numbers
                    if IBANTextFieldDelegate.heidelpayAllowedIbanNumberCharacters.contains(character) == false {
                        return false
                    }
                }
            }
        }
        
        if changedText.count <= 2 {
            for index in 0..<changedText.count {
                let characterIndex = changedText.index(changedText.startIndex, offsetBy: index)
                let characterAtIndex = String(changedText[characterIndex]).uppercased()
                if IBANTextFieldDelegate.heidelpayAllowedIbanAlphaCharacters.contains(characterAtIndex) == false {
                    return false
                }
            }
        }
        
        if hasModifiedKeyboardType {
            DispatchQueue.main.async {
                textField.resignFirstResponder()
                textField.becomeFirstResponder()
            }
        }
        
        let superResponse = super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
        
        if superResponse == true {
            if changedText != changedText.uppercased() {
                textField.text = changedText.uppercased()
                return false
            }
        }
        return superResponse
    }
    
}
