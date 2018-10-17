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
    
    /// The validated user input or nil if the input is empty
    private(set) public var userInput: CardNumberInput?
    
    private lazy var cardIconImageView: UIImageView = {
        let imageView = UIImageView(image: nil)
        imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        imageView.tintColor = theme.creditCardIconTintColor
        imageView.contentMode = .left        
        return imageView
    }()
    
    override func commonInit() {
        let initialDelegate = CardNumberTextFieldDelegate(groupingSeparator: " ", groupingMode:
            .fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 16))
        
        super.setup(placeHolder: "Card Number", internalDelegate: initialDelegate)
        
        leftViewMode = .always
        
        leftView = cardIconImageView        
    }
    
    private func setFallbackCardImage() {
        let targetSize = CGSize(width: 25, height: 40)
        cardIconImageView.image = PaymentMethod.card.icon?.heidelpay_resize(targetSize: targetSize)            
    }
    
    /// Handle a text change in the text field, check if the entered card number is valid and set userInput accordingly
    /// Sets the correct TextFieldDelegate to automatically switched grouping modes and styles depending on card type
    override func handleTextDidChangeNotification() {
        guard let internalDelegate = internalTextFieldDelegate as? CardNumberTextFieldDelegate else {
            return
        }
        
        if let cardNumber = String.heidelpay_nonEmptyCondensedString(text,
                                                groupingSeparator: internalDelegate.groupingSeparator) {
            let cardType = CardType(cardNumber: cardNumber)
            setInternalTextFieldDelegate(CardNumberTextFieldDelegate(groupingSeparator: " ",
                                                                     groupingMode: cardType.groupingMode))
            cardIconImageView.image = cardType.cardIconWithTargetSize(CGSize(width: 25, height: 40))
            
            userInput = CardNumberInput(type: cardType,
                                        normalizedCardNumber: cardNumber,
                                        formattedCardNumber: internalDelegate.groupedText(cardNumber),
                                        validationResult: cardType.validate(cardNumber: cardNumber))
            
            switch userInput!.validationResult {
            case .validChecksum, .invalidLength:
                textColor = theme.textColor
            default:
                textColor = theme.errorColor
            }
        } else {
            let groupingMode = GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 16)
            let newDelegate = CardNumberTextFieldDelegate(groupingSeparator: " ", groupingMode: groupingMode)
            setInternalTextFieldDelegate(newDelegate)
            setFallbackCardImage()
            userInput = nil
            textColor = theme.textColor
        }
    }
    
    /// Updates the internal text field delegate to handle Grouping and Formatting
    /// If the delegate change causes the text field content to change (because of a different formatting)
    /// then the text is automatically updated
    override func setInternalTextFieldDelegate(_ internalDelegate: ChainingTextFieldDelegate) {
        guard let newDelegate = internalDelegate as? CardNumberTextFieldDelegate else {
            return
        }
        if let oldDelegate = internalTextFieldDelegate as? CardNumberTextFieldDelegate {
            if oldDelegate.groupingMode == newDelegate.groupingMode {
                return
            }
        }
        
        super.setInternalTextFieldDelegate(newDelegate)
        
        let updatedGroupedText = newDelegate.groupedText(text)
        if updatedGroupedText != text {
            text = updatedGroupedText
            DispatchQueue.main.async { [weak self] in
                if let strongSelf = self {
                    strongSelf.selectedTextRange = strongSelf.textRange(from: strongSelf.endOfDocument,
                                                                        to: strongSelf.endOfDocument)
                }
            }
        }
    }
    
}
