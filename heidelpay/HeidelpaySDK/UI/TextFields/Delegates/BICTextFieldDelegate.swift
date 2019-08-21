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

/// Custom Delegate for BIC Input
class BICTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    /// Handles text change; Only allow text change if the resulting string is 3 characters or smaller
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        
        guard let bicField = textField as? BICTextField else {
            return true
        }
        
        if let text = String.heidelpay_nonEmptyCondensedString(textField.text) {
            textField.text = (text as NSString).replacingCharacters(in: range, with: string.uppercased())
        } else {
            textField.text = string.uppercased()
        }
        bicField.handleTextDidChangeNotification()
        return false
    }
    
}
