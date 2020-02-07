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

/// Custom UITextField that automatically takes care of card expiry input
/// and handles correct formatting as well as validation
///
/// The entered card expiry information can be found in the property userInput.
///
/// You can use this textfield just like any other text field including setting it's delegate.
/// Please note that if you implemented the UITextFieldDelegate method
/// textField(:shouldChangeCharactersIn:replacementString) -> Bool
/// and return false that the custom input handling logic does not take place
///
public class CardExpiryTextField: HeidelpayPaymentInfoTextField {
    
    override func commonInit() {
        setup(placeHolder: "03/20", textFieldDelegate: CardExpiryTextFieldDelegate())
        
        setNeedsInput()
    }
    
    private func setNeedsInput() {
        updateImage(image: UIImage.heidelpay_resourceImage(named: "expiry-input-empty"))
        textColor = theme.textColor
    }
    
    /// Handle a text change in the text field, check if the entered card expiry is valid and set userInput accordingly
    override func handleTextDidChangeNotification() {
        let trimmedExpiry = String.heidelpay_nonOptionalCondensedString(text)
        let cardExpiry = trimmedExpiry.replacingOccurrences(of: "/", with: "")
        
        guard cardExpiry.count == 4 else {
            setNeedsInput()
            updateValue(newValue: CardExpiryInput(expiryDate: trimmedExpiry, valid: false))
            return
        }
        
        let date = Date()
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "YY"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        var valid = true
        if let yearNumber = Int(yearFormatter.string(from: date)),
            let yearInExpiryAsNumber = Int(cardExpiry[cardExpiry.index(cardExpiry.endIndex, offsetBy: -2)...]),
            let monthNumber = Int(monthFormatter.string(from: date)),
            let monthInExpiryAsNumber = Int(cardExpiry[..<cardExpiry.index(cardExpiry.endIndex, offsetBy: -2)]) {
            if yearInExpiryAsNumber < yearNumber ||
                (yearInExpiryAsNumber == yearNumber && monthInExpiryAsNumber < monthNumber) ||
                monthInExpiryAsNumber > 12 ||
                monthInExpiryAsNumber == 0 {
                
                setHasError()
                
                valid = false
            } else {
                
                setIsValid()
                
            }
        } else {
            
            setHasError()
            valid = false
            
        }
        updateValue(newValue: CardExpiryInput(expiryDate: trimmedExpiry, valid: valid))
    }

}
