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

// swiftlint:disable all

class BICTextFieldTest: XCTestCase {

    func testBICTextEntry() {
        
        let bicTextField = BICTextField()
        
        XCTAssertNotNil(bicTextField.delegate)
        XCTAssertNotNil(bicTextField.delegate as? BICTextFieldDelegate)

        let bicDelegate = bicTextField.delegate as! BICTextFieldDelegate
        
        var rc = bicDelegate.textField(bicTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: "A")
        XCTAssertEqual(rc, false)
        
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: bicTextField)
        
        XCTAssertEqual("A", bicTextField.text)
        XCTAssertNotNil(bicTextField.value)
        XCTAssertEqual("A", bicTextField.value?.stringValue)
        XCTAssertFalse(bicTextField.value!.valid)
        
        rc = bicDelegate.textField(bicTextField, shouldChangeCharactersIn: NSRange(location: 1, length: 0), replacementString: "B")
        XCTAssertEqual(rc, false)
        
        NotificationCenter.default.post(name: UITextField.textDidChangeNotification, object: bicTextField)
        
        XCTAssertEqual("AB", bicTextField.text)
        XCTAssertNotNil(bicTextField.value)
        XCTAssertEqual("AB", bicTextField.value?.stringValue)
        XCTAssertFalse(bicTextField.value!.valid)
        /*
        XCTAssertTrue(cardNumberDelegate.textField(cardNumberTextField,
                                                   shouldChangeCharactersIn: NSRange(location: 0, length: 0),
                                                   replacementString: "4"))
        XCTAssertEqual(cardNumberTextField.text, "")
        cardNumberTextField.text = "4"
        */
    }
}
