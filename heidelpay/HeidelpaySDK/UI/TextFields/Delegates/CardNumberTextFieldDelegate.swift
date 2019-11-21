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

/// Custom delegate for Card Number Input
class CardNumberTextFieldDelegate: GroupingTextFieldDelegate {
    
    /// Handles text change; Only allow numerical input and use grouping behaviour of superclass
    public override func textField(_ textField: UITextField,
                                   shouldChangeCharactersIn range: NSRange,
                                   replacementString string: String) -> Bool {

        let originalText = String.heidelpay_nonOptionalString(textField.text)
        let changedText = (originalText as NSString).replacingCharacters(in: range, with: string)
        
        if changedText.heidelpay_condensedString().heidelpayStrictlyNumerical == false {
            return false
        }
        
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
}
