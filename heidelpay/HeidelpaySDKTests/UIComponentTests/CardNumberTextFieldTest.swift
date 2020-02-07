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

import XCTest
@testable import HeidelpaySDK

// swiftlint:disable function_body_length

class CardNumberTextFieldTest: XCTestCase {
    
    func testCardNumberTextFieldForFixedGrouping() {
        let cardNumberTextField = CardNumberTextField()
        
        let cardNumberDelegate = CardNumberTextFieldDelegate(groupingSeparator: " ",
                                                             groupingMode: CardType.visa.groupingMode)
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                                   replacementString: "4"))
        XCTAssertEqual(cardNumberTextField.text, "")
        cardNumberTextField.text = "4"
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 1, length: 0),
                                                   replacementString: "5"))
        XCTAssertEqual(cardNumberTextField.text, "4")
        cardNumberTextField.text = "45"
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 2, length: 0),
                                                   replacementString: "3"))
        XCTAssertEqual(cardNumberTextField.text, "45")
        cardNumberTextField.text = "453"
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 3, length: 0),
                                                    replacementString: "9"))
        XCTAssertEqual(cardNumberTextField.text, "4539 ")
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 4, length: 1),
                                                    replacementString: ""))
        XCTAssertEqual(cardNumberTextField.text, "453")
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 0, length: 3),
                                                    replacementString: "4539260780952"))
        XCTAssertEqual(cardNumberTextField.text, "4539 2607 8095 2")
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 16, length: 0),
                                                   replacementString: "1"))
        XCTAssertEqual(cardNumberTextField.text, "4539 2607 8095 2")
        cardNumberTextField.text = "4539 2607 8095 21"
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 17, length: 0),
                                                   replacementString: "1"))
        XCTAssertEqual(cardNumberTextField.text, "4539 2607 8095 21")
        cardNumberTextField.text = "4539 2607 8095 211"
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 18, length: 0),
                                                   replacementString: "1"))
        XCTAssertEqual(cardNumberTextField.text, "4539 2607 8095 211")
        cardNumberTextField.text = "4539 2607 8095 2111"
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 19, length: 0),
                                                    replacementString: "1"))
        XCTAssertEqual(cardNumberTextField.text, "4539 2607 8095 2111")
    }
    
    func testCardNumberTextFieldForVariableGroups() {
        let cardNumberTextField = CardNumberTextField()
        
        let cardNumberDelegate = CardNumberTextFieldDelegate(groupingSeparator: " ",
                                            groupingMode: CardType.americanExpress.groupingMode)
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                                   replacementString: "3"))
        XCTAssertEqual(cardNumberTextField.text, "")
        cardNumberTextField.text = "3"
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 1, length: 0),
                                                   replacementString: "7"))
        XCTAssertEqual(cardNumberTextField.text, "3")
        cardNumberTextField.text = "37"
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 2, length: 0),
                                                   replacementString: "0"))
        XCTAssertEqual(cardNumberTextField.text, "37")
        cardNumberTextField.text = "370"
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 3, length: 0),
                                                    replacementString: "3"))
        XCTAssertEqual(cardNumberTextField.text, "3703 ")
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 4, length: 1),
                                                    replacementString: ""))
        XCTAssertEqual(cardNumberTextField.text, "370")
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 0, length: 3),
                                                    replacementString: "37035549687"))
        XCTAssertEqual(cardNumberTextField.text, "3703 554968 7")
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 11, length: 2),
                                                    replacementString: ""))
        XCTAssertEqual(cardNumberTextField.text, "3703 554968 ")
    }
    
    func testCardNumberTextFieldForFixedGroupsWithVariableLength() {
        let cardNumberTextField = CardNumberTextField()
        
        let cardNumberDelegate = CardNumberTextFieldDelegate(groupingSeparator: " ",
                                                             groupingMode: CardType.maestro.groupingMode)
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                                   replacementString: "6"))
        XCTAssertEqual(cardNumberTextField.text, "")
        cardNumberTextField.text = "6"
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 1, length: 0),
                                                   replacementString: "7"))
        XCTAssertEqual(cardNumberTextField.text, "6")
        cardNumberTextField.text = "67"
        
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 2, length: 0),
                                                   replacementString: "0"))
        XCTAssertEqual(cardNumberTextField.text, "67")
        cardNumberTextField.text = "670"
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 3, length: 0),
                                                    replacementString: "3"))
        XCTAssertEqual(cardNumberTextField.text, "6703 ")
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 0, length: 4),
                                                    replacementString: "67891234123412341234"))
        XCTAssertEqual(cardNumberTextField.text, "6789 1234 1234 1234 123")
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 0, length: 4),
                                                    replacementString: "6789123412341234123"))
        XCTAssertEqual(cardNumberTextField.text, "6789 1234 1234 1234 123")
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 0, length: 4),
                                                    replacementString: "67891234123412341 abc"))
        
        XCTAssertEqual(cardNumberTextField.text, "6789 1234 1234 1234 123")
        
        XCTAssertFalse(cardNumberDelegate.textField(cardNumberTextField,
                                                    shouldChangeCharactersIn: NSRange(location: 0, length: 4),
                                                    replacementString: "12736123€"))
        XCTAssertEqual(cardNumberTextField.text, "6789 1234 1234 1234 123")
    }
    
}
