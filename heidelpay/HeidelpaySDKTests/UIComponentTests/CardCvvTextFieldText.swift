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


import XCTest
@testable import HeidelpaySDK

// swiftlint:disable function_body_length

class CardCvvTextFieldTest: XCTestCase {
    
    func testCvvTextField() {
        let cvvTexField = CardCvvTextField()
        
        let cvvDelegate = CardCvvTextFieldDelegate()
        
        XCTAssertEqual(cvvTexField.text, "")
        XCTAssertTrue(cvvDelegate.textField(cvvTexField,
                                            shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                            replacementString: "1"))
        XCTAssertEqual(cvvTexField.text, "")
        
        cvvTexField.text = "1"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: cvvTexField)
        XCTAssertNotNil(cvvTexField.value)
        XCTAssertEqual(cvvTexField.value?.stringValue, "1")
        XCTAssertFalse(cvvTexField.value!.valid)
        XCTAssertTrue(cvvDelegate.textField(cvvTexField,
                                            shouldChangeCharactersIn: NSRange(location: 1, length: 0),
                                            replacementString: "1"))
        XCTAssertEqual(cvvTexField.text, "1")
        
        cvvTexField.text = "11"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: cvvTexField)
        XCTAssertNotNil(cvvTexField.value)
        XCTAssertEqual(cvvTexField.value?.stringValue, "11")
        XCTAssertFalse(cvvTexField.value!.valid)
        XCTAssertTrue(cvvDelegate.textField(cvvTexField,
                                            shouldChangeCharactersIn: NSRange(location: 2, length: 0),
                                            replacementString: "1"))
        XCTAssertEqual(cvvTexField.text, "11")
        
        cvvTexField.text = "111"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: cvvTexField)
        XCTAssertNotNil(cvvTexField.value)
        XCTAssertEqual(cvvTexField.value?.stringValue, "111")
        XCTAssertTrue(cvvTexField.value!.valid)
        XCTAssertFalse(cvvDelegate.textField(cvvTexField,
                                             shouldChangeCharactersIn: NSRange(location: 3, length: 0),
                                             replacementString: "1"))
        XCTAssertEqual(cvvTexField.text, "111")
        
        XCTAssertTrue(cvvDelegate.textField(cvvTexField,
                                            shouldChangeCharactersIn: NSRange(location: 2, length: 1),
                                            replacementString: ""))
        XCTAssertEqual(cvvTexField.text, "111")
        
        cvvTexField.text = "11"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: cvvTexField)
        XCTAssertNotNil(cvvTexField.value)
        XCTAssertEqual(cvvTexField.value?.stringValue, "11")
        XCTAssertFalse(cvvTexField.value!.valid)
        
        cvvTexField.text = nil
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: cvvTexField)
        XCTAssertNil(cvvTexField.value)
        XCTAssertTrue(cvvDelegate.textField(cvvTexField,
                                            shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                            replacementString: "1"))
    }
}
