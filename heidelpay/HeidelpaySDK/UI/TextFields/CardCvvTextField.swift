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

/// Custom UITextField that automatically takes care of card cvv input
/// and handles correct validation
///
/// The entered card cvv information can be found in the property userInput.
///
/// You can use this textfield just like any other text field including setting it's delegate.
/// Please note that if you implemented the UITextFieldDelegate method
/// textField(:shouldChangeCharactersIn:replacementString) -> Bool
/// and return false that the custom input handling logic does not take place
///
public class CardCvvTextField: HeidelpayPaymentInfoTextField {
    
    /// the validated input from the user or nil if the input is empty
    private(set) public var userInput: CardCvvInput?
    
    override func commonInit() {
        setup(placeHolder: "CVC", internalDelegate: CardCvvTextFieldDelegate())
        
        isSecureTextEntry = true
    }
    
    /// Handle a text change in the text field, check if the entered CVV is valid and set userInput accordingly
    override func handleTextDidChangeNotification() {
        if let cardCVV = String.heidelpay_asNonEmptyStringWithoutWhitespaces(text) {
            if cardCVV.count == 3 {
                userInput = CardCvvInput(cvv: cardCVV, valid: true)
            } else {
                userInput = CardCvvInput(cvv: cardCVV, valid: false)
            }
        } else {
            userInput = nil
        }
    }
}
