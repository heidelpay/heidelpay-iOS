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

struct InvalidPaymentTypeAsNotCodable: CreatePaymentType {
    let method: PaymentMethod = .card    
}

class CreatePaymentTypeRequestTest: XCTestCase {

    func testErrorWhenNotCodable() {
        let request = CreatePaymentTypeRequest(type: InvalidPaymentTypeAsNotCodable())
        
        XCTAssertThrowsError(try request.encodeAsJSON(), "shall throw") { (error) in
            if let error = error as? BackendError {
                XCTAssertEqual(error, .invalidRequest)
            } else {
                XCTFail("wrong error type")
            }
        }
    }
    
    func testCardCreatePath() {
        guard let cardPayment = CardPayment(number: "123456789012345678", cvc: "123",
                                            expiryMonth: 10, expiryYear: 22) else {
            XCTFail("shall not be nil")
            return
        }
        let request = CreatePaymentTypeRequest(type: cardPayment)
        XCTAssertEqual(request.requestPath, "types/card")
    }

}
