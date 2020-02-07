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
    
    override func commonInit() {
        setup(placeHolder: "DE56 5199 2312 3609 7838 68",
              textFieldDelegate: IBANTextFieldDelegate(), keyboardType: .alphabet)
        
        autocapitalizationType = .allCharacters
        autocorrectionType = .no
        
        setNeedsInput()
    }
    
    private func setNeedsInput() {
        updateImage(image: UIImage.heidelpay_resourceImage(named: "card-debit"))
        textColor = theme.textColor
    }
    
    /// Handle a text change in the text field, check if the entered IBAN is valid and set userInput accordingly
    override func handleTextDidChangeNotification() {
        if let iban = String.heidelpay_asNonEmptyStringWithoutWhitespaces(text) {
            let validationResult = PaymentTypeInformationValidator.shared.validate(iban: iban)
            let value = IbanInput(iban: iban, validationResult: validationResult)
            updateValue(newValue: value)
            switch validationResult {
            case .validChecksum:
                setIsValid()
            case .invalidLength:
                setNeedsInput()
            case .invalidChecksum:
                setHasError()
            case .invalidCharacters:
                setHasError()
            }
        } else {
            setNeedsInput()
            updateValue(newValue: nil)
        }
    }

}
