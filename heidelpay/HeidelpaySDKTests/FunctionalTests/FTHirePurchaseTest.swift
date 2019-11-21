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
class FTHirePurchaseTest: FTBaseTest {
        
    func testRetrieveHirePurchasePlansAndCreatePaymentType() {
        let heidelPay = setupHeidelpay()
        
        let expRetrieve = expectation(description: "retrieve hire purchase plans")
        
        var firstPlan: HirePurchasePlan?
        heidelPay.retrieveHirePurchasePlans(amount: 100,
                                            currencyCode: "EUR",
                                            effectiveInterest: 5.99) { (result) in
            
            let plans = try? result.get()
            XCTAssertNotNil(plans)
            XCTAssertTrue(plans!.count > 0)
            
            firstPlan = plans?.first
                                                
            expRetrieve.fulfill()
        }
        waitForExpectations(timeout: 10.0, handler: nil)
        
        XCTAssertNotNil(firstPlan)
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createPaymentHirePurchase(iban: "DE46940594210000012345",
                                            bic: "COBADEFFXXX",
                                            holder: "Manuel Weißmann",
                                            plan: firstPlan!) { (paymentType, error) in
            
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
