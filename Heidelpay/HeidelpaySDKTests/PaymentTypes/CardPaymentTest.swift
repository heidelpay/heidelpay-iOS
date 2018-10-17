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

class CardPaymentTest: XCTestCase {

    func testConstructCardPaymentData() {
        
        XCTAssertNotNil(CardPayment(number: "123456789012345678", cvc: "123", expiryMonth: 10, expiryYear: 22))
        XCTAssertNotNil(CardPayment(number: "123456789012345678", cvc: "123", expiryMonth: 10, expiryYear: 2022))
        XCTAssertNotNil(CardPayment(number: "123456789012345678", cvc: "123", expiryMonth: 1, expiryYear: 2022))
        
    }
    
    func testMonthAndYearTwoDigitFormat() {
        
        let cc1 = CardPayment(number: "123456789012345678", cvc: "123", expiryMonth: 1, expiryYear: 2020)
        XCTAssertEqual(cc1?.expiryDate, "01/20")

        let cc2 = CardPayment(number: "123456789012345678", cvc: "123", expiryMonth: 10, expiryYear: 20)
        XCTAssertEqual(cc2?.expiryDate, "10/20")

    }
    
    func testInvalidCardPaymentData() {
        XCTAssertNil(CardPayment(number: "1234567890", cvc: "123", expiryMonth: 1, expiryYear: 2022))
        XCTAssertNil(CardPayment(number: "123456789012345678", cvc: "1", expiryMonth: 10, expiryYear: 22))
        XCTAssertNil(CardPayment(number: "123456789012345678", cvc: "123", expiryMonth: 0, expiryYear: 22))
        XCTAssertNil(CardPayment(number: "123456789012345678", cvc: "123", expiryMonth: 10, expiryYear: 2000))
        XCTAssertNil(CardPayment(number: "123456789012345678", cvc: "123", expiryMonth: 13, expiryYear: 20))
    }

}
