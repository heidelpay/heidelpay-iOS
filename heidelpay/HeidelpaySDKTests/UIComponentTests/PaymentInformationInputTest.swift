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

class PaymentInformationInputTest: XCTestCase {
    
    func testCardExpiry() {
        XCTAssertEqual(1, CardExpiryInput(expiryDate: "01/15", valid: true).month)
        XCTAssertEqual(2015, CardExpiryInput(expiryDate: "01/15", valid: true).year)
        
        XCTAssertEqual(-1, CardExpiryInput(expiryDate: "15/15", valid: false).month)
        XCTAssertEqual(-1, CardExpiryInput(expiryDate: "00/15", valid: false).month)
        XCTAssertEqual(2021, CardExpiryInput(expiryDate: "15/21", valid: false).year)
        
        XCTAssertEqual(-1, CardExpiryInput(expiryDate: "15/2", valid: false).year)
        
        XCTAssertEqual(-1, CardExpiryInput(expiryDate: "15/2345", valid: false).year)
        
        XCTAssertEqual(-1, CardExpiryInput(expiryDate: "1", valid: false).month)
    }
}
