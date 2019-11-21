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

class PaymentTypeTest: XCTestCase {

    func testPaymentTypesFromJSONArray() {
        
        let json = [
            ["method": "paypal", "id": "A123456"],
            ["method": "sofort", "id": "B123456"],
            ["method": "card", "id": "B123456", "brand": "Mastercard", "number": "****1233"]
        ]
        
        let paymentTypes = PaymentType.map(jsonArray: json)
        XCTAssertEqual(paymentTypes.count, 3)
        XCTAssertNotNil(paymentTypes[2].title)
        XCTAssertEqual(paymentTypes[2].title, "Mastercard")
        
    }

}
