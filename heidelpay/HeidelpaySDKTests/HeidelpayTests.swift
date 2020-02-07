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

class HeidelpayTests: XCTestCase {
    static let TestPublicKey = PublicKey("s-pub-2a10ifVINFAjpQJ9qW8jBe5OJPBx6Gxa")
    var testBackendService = TestBackendService()
    
    override func setUp() {
        Heidelpay.backendServiceCreator = { (publicKey, environment) in
            return self.testBackendService
        }
        
        testBackendService.mock(path: "keypair", withJsonResponse: """
{
  "publicKey" : "s-pub-2a10ifVINFAjpQJ9qW8jBe5OJPBx6Gxa",
  "availablePaymentTypes" : [ "card", "sofort" ]
}
""")

    }
    
    func testCreateInstance() {
        
        let excpectSetupSucceed = expectation(description: "setup succeed")
        
        Heidelpay.setup(publicKey: HeidelpayTests.TestPublicKey) { (heidelPay, error) in
            
            excpectSetupSucceed.fulfill()
            
            XCTAssertNil(error)
            XCTAssertNotNil(heidelPay)
            
            XCTAssertEqual(heidelPay!.paymentMethods.count, 2)
            XCTAssertTrue(heidelPay!.paymentMethods.contains(.card))
            
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testAuthorizeError() {
        testBackendService.mock(path: "keypair",
                                withResponse: MockedBackendErrorResponse(.serverHTTPError(httpCode: 401)))
        
        let expSetup = expectation(description: "setup")
        
        Heidelpay.setup(publicKey: HeidelpayTests.TestPublicKey) { (_, error) in
            XCTAssertNotNil(error)
            switch error! {
            case .notAuthorized:
                XCTAssertTrue(true)
            default:
                XCTFail("wrong error type")
            }

            expSetup.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testCreateCardPayment() {
        let setupExp = expectation(description: "setup succeed")
        var heidelPay: Heidelpay?
        
        Heidelpay.setup(publicKey: HeidelpayTests.TestPublicKey) { (heidelPayInstance, _) in
            setupExp.fulfill()
            
            heidelPay = heidelPayInstance
        }
        waitForExpectations(timeout: 0.1, handler: nil)
        XCTAssertNotNil(heidelPay)
        
        testBackendService.mock(path: "types/card", withJsonResponse: """
{
  "id" : "s-crd-avf2geyehjro",
  "method" : "card"
}
""")
        
        let paymentExp = expectation(description: "payment created")
        
        guard let card = CardPayment(number: "4444333322221111", cvc: "123", expiryMonth: 4, expiryYear: 25) else {
            XCTFail("shall be valid card values")
            return
        }
        heidelPay?.createPayment(type: card) { (paymentType, error) in

            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.paymentId)
            XCTAssertEqual(paymentType?.method, .card)
            
            paymentExp.fulfill()
        }
        waitForExpectations(timeout: 0.1, handler: nil)
        
    }
    
    func testFrameworkVersion() {
                
        XCTAssertEqual(Heidelpay.sdkVersion, "1.2")
        
    }

}
