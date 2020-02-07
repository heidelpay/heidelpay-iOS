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

class FTCreateBasketTest: FTBaseTest {
    
    func testCreateBasket() {
        
        let heidelPay = setupHeidelpay()
        
        let items = [
            BasketItem(referenceId: "item1", title: "Item 1", quantity: 1, amountPerUnit: 100),
            BasketItem(referenceId: "item2", title: "Item 2", quantity: 1, amountPerUnit: 10)
        ]
        let basket = Basket(orderId: "myorder-1", items: items, amountTotalGross: 110)
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createBasket(basket, completion: { basketId, error in
            XCTAssertNotNil(basketId)
            XCTAssertNil(error)
            
            expCreate.fulfill()
        })
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
