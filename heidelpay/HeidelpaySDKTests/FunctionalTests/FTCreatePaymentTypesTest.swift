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

// swiftlint:disable function_body_length

import XCTest

// Importing heidelpay as normal framework. Only public and open elements are visible
import HeidelpaySDK

/// Functional Tests of the heidelpay SDK with real backend!
///
/// **Note**: This tests may fail in case of changes in the backend. Nothing is mocked.
///
class FTCreatePaymentTypesTest: FTBaseTest {
    
    func testErrorWhenNoStrongReference() {
        let expCreate = expectation(description: "create")
        
        let key = FTBaseTest.testPublicKey
        Heidelpay.setup(publicKey: key) { (heidelPayInstance, error) in
        
            heidelPayInstance?.createPaymentCard(number: "4444333322221111",
                                    cvc: "123",
                                    expiryDate: "04/25") { (_, error) in
                                                            
                XCTAssertNotNil(error)
                                        
                expCreate.fulfill()
            }
        }
        waitForExpectations(timeout: 10.0, handler: nil)
        
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
            XCTAssertNotNil(paymentType?.data?["brand"])
            XCTAssertNotNil(paymentType?.data?["expiryDate"])
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
                                        
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
        
        let expCreate2 = expectation(description: "create 3ds = false")
        
        heidelPay.createPaymentCard(number: "4444333322221111",
                                    cvc: "123",
                                    expiryDate: "04/25",
                                    use3ds: false) { (paymentType, error) in
            
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNotNil(paymentType?.data?["number"])
            XCTAssertNotNil(paymentType?.data?["brand"])
            XCTAssertNotNil(paymentType?.data?["expiryDate"])
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
                                        
            expCreate2.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
        
        let expCreate3 = expectation(description: "create 3ds = explicit set to true")
        
        heidelPay.createPaymentCard(number: "4444333322221111",
                                    cvc: "123",
                                    expiryDate: "04/25",
                                    use3ds: true) { (paymentType, error) in
            
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNotNil(paymentType?.data?["number"])
            XCTAssertNotNil(paymentType?.data?["brand"])
            XCTAssertNotNil(paymentType?.data?["expiryDate"])
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
                                        
            expCreate3.fulfill()
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
    // swiftlint:disable line_length
    func testCreateApplePay() {
        let heidelPay = setupHeidelpay()
        
        let sampleApplePayTransactionJSON = """
        {
        "version":"EC_v1",
        "data":"32wNUOV/SirrVHNV/IyEMrVE733qzFhGLwlcgFfG4QDBTytusn/Ie1DbnoIlOm6iGeCvxHxicoH1c2yuvQPKuyCRWvz35KTu8GQCQ6+l8CJ4dSPsn/8IM/I8rq/LyFzsWRrxfZkP6FwRd+bOB81pKYugr90HECo2SBlW6j0T2pjZLNw7rGTFCq2hllgasCVsyAAcoHA4TOZ1lDYx2g8NAD0krD/CxrSPixekCKUagTqCeA2Al3zvhc8CiTkHvTJcz62g2FgmLq2sDR1+2b000QPGr69tzYaUUgCRcvHJVh+9AuesjlOeM53637alriGYsJ+ZD0r5cW8T9EptE4cE38EWC+d7jjXg4iKFYYfu1n5RggYHf+p19ydvQ24wS8miJcOmnhgQDsz/4nXv1uYlyzgZTdGqAUl2FIWMXwmjHbE=",
        "signature":"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",
        "header":{
        "ephemeralPublicKey":"MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEaGe+L4FIP3kSN+GEKWT/6Yh0quxKKyUahQO2SW+0xNKqB0ocC1DKbclbGq2RQg7n1PBM1OuYDxvwDcPBnpfnkw==",
        "publicKeyHash":"M2yzlpBsH3GwH5jTV9GgKC7bAUdeIOIfjwQhoKjg5+s=",
        "transactionId":"b9e1338924cca43341152525553e9b97d3fb94e2e5ce3a84d4456255082444bb"
        }
        }
"""
        
        let data = sampleApplePayTransactionJSON.data(using: .utf8)!
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createApplePay(paymentTokenData: data) { (paymentType, error) in
                                        
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
}

extension FTCreatePaymentTypesTest {
    
    func testCreateAlipay() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentAlipay { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreateWeChatPay() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentWeChatPay { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreatePIS() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentPIS { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreateInvoiceFactoring() {
        let heidelPay = setupHeidelpay()
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentInvoiceFactoring { (paymentType, error) in
            XCTAssertNotNil(paymentType)
            XCTAssertNil(error)
            XCTAssertNotNil(paymentType?.data)
            XCTAssertNil(paymentType?.data?["id"])
            XCTAssertNil(paymentType?.data?["method"])
            expCreate.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
