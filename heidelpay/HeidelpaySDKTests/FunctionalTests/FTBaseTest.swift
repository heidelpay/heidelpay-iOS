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

// Importing heidelpay as normal framework. Only public and open elements are visible
import HeidelpaySDK

/// base test class for functional tests
class FTBaseTest: XCTestCase {
    
    static var testPublicKey: PublicKey {
        return PublicKey("s-pub-2a10ifVINFAjpQJ9qW8jBe5OJPBx6Gxa")
    }

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
    }

    func setupHeidelpay() -> Heidelpay {
        let key = FTBaseTest.testPublicKey

        let expSetup = expectation(description: "setup")
        var heidelPay: Heidelpay?
        
        Heidelpay.setup(publicKey: key) { (heidelPayInstance, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(heidelPayInstance)
            expSetup.fulfill()
            
            heidelPay = heidelPayInstance
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
        return heidelPay!
    }
    
    func testSetup() {
        _ = setupHeidelpay()
    }

}
