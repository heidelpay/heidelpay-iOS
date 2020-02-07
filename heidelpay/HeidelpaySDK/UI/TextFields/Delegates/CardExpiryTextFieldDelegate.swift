// =======
// Copyright 2020 Heidelpay GmbH
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

/// Custom Delegate for Card Expiry input
class CardExpiryTextFieldDelegate: NSObject, UITextFieldDelegate {

    /// Handles text change; Automatically handles the following tasks:
    ///     - validate input so that the user cannot enter invalid months,
    ///     - add and remove '/' separator between month and year,
    ///     - automatically add leading zeros for month (e.g. if the user starts with a 2 or higher)
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        
        if let text = textField.text {
            var changedText = (text as NSString).replacingCharacters(in: range, with: string)
            
            if changedText.count == 1 {
                if changedText != "0" && changedText != "1" {
                    textField.text = "0\(changedText)/"
                    return false
                }
            } else if changedText.count == 2 {
                if changedText.heidelpay_isValidExpiryMonth() == false {
                    return false
                }
                
                if String.heidelpay_hasRemovedSingleCharacterFrom(originalText: text, changedText: changedText) {
                    changedText.removeLast()
                    textField.text = changedText
                    return false
                } else if String.heidelpay_hasAddedSingleCharacterTo(originalText: text, changedText: changedText) {
                    textField.text = "\(changedText)/"
                    return false
                }
            } else if (changedText.count == 3 || text.count == 4) && text.count > changedText.count {
                changedText.removeLast()
                textField.text = changedText
                return false
            } else if changedText.count > 5 {
                return false
            }
        }
        
        return true
    }
}

extension String {
    
    static func heidelpay_hasRemovedSingleCharacterFrom(originalText: String?, changedText: String?) -> Bool {
        let original = originalText != nil ? originalText! : ""
        let changed = changedText != nil ? changedText! : ""
        
        return changed.count == (original.count - 1) && original.hasPrefix(changed)
    }
    
    static func heidelpay_hasAddedSingleCharacterTo(originalText: String?, changedText: String?) -> Bool {
        let original = originalText != nil ? originalText! : ""
        let changed = changedText != nil ? changedText! : ""
        
        return changed.count == (original.count + 1) && changed.hasPrefix(original)
    }
    
    func heidelpay_isValidExpiryMonth() -> Bool {
        if self.count != 2 {
            return false
        }
        
        if self == "00" {
            return false
        } else if let intValue = Int(self), intValue > 12 || intValue <= 0 {
            return false
        }
        return true
    }
}
