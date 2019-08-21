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

class CardExpiryTextFieldTest: XCTestCase {
    
    func testExpiryTextField() {
        let expiryTextField = CardExpiryTextField()
        
        expiryTextField.text = nil
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertNotNil(expiryTextField.value)
        XCTAssertEqual(expiryTextField.value?.stringValue, "")
        XCTAssertFalse(expiryTextField.value!.valid)
        
        expiryTextField.text = ""
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        
        XCTAssertEqual(expiryTextField.text, "")
        let expiryDelegate = CardExpiryTextFieldDelegate()
        XCTAssertTrue(expiryDelegate.textField(expiryTextField,
                                               shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                               replacementString: "0"))
        XCTAssertEqual(expiryTextField.text, "")
        expiryTextField.text = "0"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        
        XCTAssertFalse(expiryDelegate.textField(expiryTextField,
                                                shouldChangeCharactersIn: NSRange(location: 1, length: 0),
                                                replacementString: "1"))
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertEqual(expiryTextField.text, "01/")
        
        XCTAssertTrue(expiryDelegate.textField(expiryTextField,
                                               shouldChangeCharactersIn: NSRange(location: 3, length: 0),
                                               replacementString: "2"))
        XCTAssertEqual(expiryTextField.text, "01/")
        expiryTextField.text = "01/2"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        
        XCTAssertTrue(expiryDelegate.textField(expiryTextField,
                                               shouldChangeCharactersIn: NSRange(location: 4, length: 0),
                                               replacementString: "3"))
        XCTAssertEqual(expiryTextField.text, "01/2")
        expiryTextField.text = "01/23"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertNotNil(expiryTextField.value)
        XCTAssertEqual(expiryTextField.value?.stringValue, "01/23")
        XCTAssertTrue(expiryTextField.value!.valid)
        
        XCTAssertFalse(expiryDelegate.textField(expiryTextField,
                                                shouldChangeCharactersIn: NSRange(location: 5, length: 0),
                                                replacementString: "1"))
        XCTAssertEqual(expiryTextField.text, "01/23")
        
        XCTAssertTrue(expiryDelegate.textField(expiryTextField,
                                               shouldChangeCharactersIn: NSRange(location: 4, length: 1),
                                               replacementString: ""))
        XCTAssertEqual(expiryTextField.text, "01/23")
        
        expiryTextField.text = "01/1"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertFalse(expiryTextField.value!.valid)
        
        XCTAssertFalse(expiryDelegate.textField(expiryTextField,
                                                shouldChangeCharactersIn: NSRange(location: 3, length: 1),
                                                replacementString: ""))
        XCTAssertEqual(expiryTextField.text, "01")
        
        XCTAssertTrue(expiryDelegate.textField(expiryTextField,
                                               shouldChangeCharactersIn: NSRange(location: 1, length: 1),
                                               replacementString: ""))
        XCTAssertEqual(expiryTextField.text, "01")
        
        expiryTextField.text = "0"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertFalse(expiryTextField.value!.valid)
        XCTAssertFalse(expiryDelegate.textField(expiryTextField,
                                                shouldChangeCharactersIn: NSRange(location: 1, length: 0),
                                                replacementString: "0"))
        XCTAssertEqual(expiryTextField.text, "0")
        
        expiryTextField.text = ""
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertFalse(expiryDelegate.textField(expiryTextField,
                                                shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                                replacementString: "2"))
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertNotNil(expiryTextField.value)
        XCTAssertEqual(expiryTextField.value?.stringValue, "02/")
        XCTAssertFalse(expiryTextField.value!.valid)
        XCTAssertEqual(expiryTextField.text, "02/")
        
        XCTAssertFalse(expiryDelegate.textField(expiryTextField,
                                                shouldChangeCharactersIn: NSRange(location: 2, length: 1),
                                                replacementString: ""))
        XCTAssertEqual(expiryTextField.text, "0")
        
        expiryTextField.text = "1"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertFalse(expiryDelegate.textField(expiryTextField,
                                                shouldChangeCharactersIn: NSRange(location: 1, length: 0),
                                                replacementString: "4"))
        XCTAssertEqual(expiryTextField.text, "1")
        
        expiryTextField.text = "01/16"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertNotNil(expiryTextField.value)
        XCTAssertEqual(expiryTextField.value?.stringValue, "01/16")
        XCTAssertFalse(expiryTextField.value!.valid)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/YY"
        expiryTextField.text = formatter.string(from: Date())
        
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertNotNil(expiryTextField.value)
        XCTAssertTrue(expiryTextField.value!.valid)
        
        expiryTextField.text = "00/23"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertNotNil(expiryTextField.value)
        XCTAssertFalse(expiryTextField.value!.valid)
        
        expiryTextField.text = "14/23"
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: expiryTextField)
        XCTAssertNotNil(expiryTextField.value)
        XCTAssertFalse(expiryTextField.value!.valid)
    }
}
