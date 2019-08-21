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

/// Custom UITextField for BIC entry. Sets a placeholder and an icon and
/// customizes the keyboard for entry of uppercase letters only
///
/// The entered BIC can be found in the property userInput.
///
public class BICTextField: HeidelpayPaymentInfoTextField {
    
    override func commonInit() {
        setup(placeHolder: "STZZATWWXXX", textFieldDelegate: BICTextFieldDelegate(), keyboardType: .alphabet)
        
        autocapitalizationType = .allCharacters
        autocorrectionType = .no
        
        setNeedsInput()
    }
    
    private func setNeedsInput() {
        updateImage(image: UIImage.heidelpay_resourceImage(named: "card-debit"))
        textColor = theme.textColor
    }
    
    /// Handle a text change in the text field, check if the entered BIC is valid
    /// and set userInput accordingly
    override func handleTextDidChangeNotification() {
        if let bic = String.heidelpay_asNonEmptyStringWithoutWhitespaces(text) {
            updateValue(newValue: BICInput(bic: bic))
        } else {
            setNeedsInput()
            updateValue(newValue: nil)
        }
    }
    
}
