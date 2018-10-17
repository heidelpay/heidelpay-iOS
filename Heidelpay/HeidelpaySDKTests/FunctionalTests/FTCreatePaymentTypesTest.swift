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

// Importing heidelpay as normal framework. Only public and open elements are visible
import HeidelpaySDK

/// Functional Tests of the heidelpay SDK with real backend!
///
/// **Note**: This tests may fail in case of changes in the backend. Nothing is mocked.
///
class FTCreatePaymentTypesTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
    }

    private func setupHeidelpay() -> Heidelpay {
        let key = PublicKey("s-pub-2a10ifVINFAjpQJ9qW8jBe5OJPBx6Gxa")

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
    
    func testCreateCardPayment() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentCard(number: "4444333322221111",
                                    cvc: "123",
                                    expiryDate: "04/25") { (paymentType, error) in
            
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNotNil(paymentType?.data?["number"])
            XCTAssertNotNil(paymentType?.data?["expiryDate"])
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
    func testCreateSepaDirectDebit() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentSepaDirect(iban: "DE89370400440532013000",
                                          bic: nil,
                                          holder: nil) { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNotNil(paymentType?.data?["iban"])
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func testCreateSepaDirectDebitGuaranteed() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentSepaDirect(iban: "DE89370400440532013000", bic: nil, holder: nil,
                                          guaranteed: true) { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNotNil(paymentType?.data?["iban"])
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreateInvoice() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentInvoice { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertEqual(0, paymentType?.data?.count)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreateInvoiceGuaranteed() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentInvoice(guaranteed: true) { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertEqual(0, paymentType?.data?.count)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreateSofort() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentSofort { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertEqual(0, paymentType?.data?.count)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCreateGiropay() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentGiropay { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertEqual(0, paymentType?.data?.count)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCreatePrepayment() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentPrepayment { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertEqual(0, paymentType?.data?.count)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCreatePrzelewy24() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentPrzelewy24 { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertEqual(0, paymentType?.data?.count)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testCreatePaypal() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentPaypal { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertEqual(0, paymentType?.data?.count)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreateIdeal() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentIdeal(bic: "RABONL2U") { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertEqual(1, paymentType?.data?.count)
            XCTAssertNotNil(paymentType?.data?["bic"])
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
