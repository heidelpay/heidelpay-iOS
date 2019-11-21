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

/// Custom UITextField that automatically takes care of card number input and handles grouping as well as validation
///
/// Uses the enum CardType for validation and parsing of card nubmers
///
/// The entered card number information can be found in the property userInput.
///
/// You can use this textfield just like any other text field including setting it's delegate.
/// Please note that if you implemented the UITextFieldDelegate method
/// textField(:shouldChangeCharactersIn:replacementString) -> Bool
/// and return false that the custom input handling logic does not take place
///
public class CardNumberTextField: HeidelpayPaymentInfoTextField {    
    
    override func commonInit() {
        let initialDelegate = CardNumberTextFieldDelegate(groupingSeparator: " ", groupingMode:
            .fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 16))
        
        super.setup(placeHolder: "1234 1234 1234 1234", textFieldDelegate: initialDelegate)
        
        updateImage(image: CardType.placeholderIcon)
    }
    
    /// Handle a text change in the text field, check if the entered card number is valid and set userInput accordingly
    /// Sets the correct TextFieldDelegate to automatically switched grouping modes and styles depending on card type
    override func handleTextDidChangeNotification() {
        guard let internalDelegate = delegate as? CardNumberTextFieldDelegate else {
            return
        }
        
        if let cardNumber = String.heidelpay_nonEmptyCondensedString(text,
                                                groupingSeparator: internalDelegate.groupingSeparator) {
            let cardType = CardType(cardNumber: cardNumber)
            /*
            setInternalTextFieldDelegate(CardNumberTextFieldDelegate(groupingSeparator: " ",
                                                                     groupingMode: cardType.groupingMode))
            */
            updateImage(image: cardType.icon)
            
            let cardInput = CardNumberInput(type: cardType,
                                            normalizedCardNumber: cardNumber,
                                            formattedCardNumber: internalDelegate.groupedText(cardNumber),
                                            validationResult: cardType.validate(cardNumber: cardNumber))
            
            switch cardInput.validationResult {
            case .validChecksum:
                textColor = theme.textColor
                
            case .invalidLength:
                textColor = theme.textColor
                
            default:
                textColor = theme.errorColor
            }
            
            updateValue(newValue: cardInput)
        } else {
            
            updateImage(image: CardType.placeholderIcon)
            
            //let groupingMode = GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 16)
            //let newDelegate = CardNumberTextFieldDelegate(groupingSeparator: " ", groupingMode: groupingMode)
            //setInternalTextFieldDelegate(newDelegate)
            
            updateValue(newValue: nil)
            textColor = theme.textColor
        }
    }
    
}
