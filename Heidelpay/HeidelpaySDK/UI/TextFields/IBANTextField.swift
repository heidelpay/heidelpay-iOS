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

/// Custom UITextField that automatically takes care of iban input
/// and handles correct formatting as well as validation
///
/// The entered iban information can be found in the property userInput.
///
/// You can use this textfield just like any other text field including setting it's delegate.
/// Please note that if you implemented the UITextFieldDelegate method
/// textField(:shouldChangeCharactersIn:replacementString) -> Bool
/// and return false that the custom input handling logic does not take place
///
public class IBANTextField: HeidelpayPaymentInfoTextField {
    
    /// the validated input from the user or nil if the input is empty
    private(set) public var userInput: IbanInput?
    
    override func commonInit() {
        setup(placeHolder: "IBAN", internalDelegate: IBANTextFieldDelegate(), keyboardType: .alphabet)
        
        autocapitalizationType = .allCharacters
        autocorrectionType = .no        
    }
    
    /// Handle a text change in the text field, check if the entered IBAN is valid and set userInput accordingly
    override func handleTextDidChangeNotification() {
        if let iban = String.heidelpay_asNonEmptyStringWithoutWhitespaces(text) {
            let validationResult = PaymentTypeInformationValidator.shared.validate(iban: iban)
            userInput = IbanInput(iban: iban, validationResult: validationResult)
        } else {
            userInput = nil
        }
    }

}
