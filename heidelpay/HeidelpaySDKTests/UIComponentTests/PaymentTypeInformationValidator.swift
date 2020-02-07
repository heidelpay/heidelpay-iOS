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

class PaymentTypeInformationValidatorTest: XCTestCase {
    let validator = PaymentTypeInformationValidator.shared
    
    func testValidIBANs() {
        
        XCTAssertEqual(.validChecksum, validator.validate(iban: "GB82 WEST 1234 5698 7654 32"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "GB82 WEST \n1234     56987654\n\n 32"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "     GB82 WEST 1234 5698 7654 3  2    "))
            
        XCTAssertEqual(.validChecksum, validator.validate(iban: "BE71 0961 2345 6769"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "FR76 3000 6000 0112 3456 7890 189"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "DE91 1000 0000 0123 4567 89"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "GR96 0810 0010 0000 0123 4567 890"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "RO09 BCYP 0000 0012 3456 7890"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "SA44 2000 0001 2345 6789 1234"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "ES79 2100 0813 6101 2345 6789"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "CH56 0483 5012 3456 7800 9"))
        XCTAssertEqual(.validChecksum, validator.validate(iban: "GB98 MIDL 0700 9312 3456 78"))
    }
    
    func testInvalidIBANCharaters() {
        
        XCTAssertEqual(.invalidCharacters, validator.validate(iban: "ÖGB82 WEST 1234 5698 7654 32"))
        
    }
    
    func testInvalidIBANLength() {
        
        XCTAssertEqual(.invalidLength, validator.validate(iban: "GB1"))
        
    }
    
    func testValidCardNumbers() {
        
        XCTAssertEqual(.validChecksum, validator.validate(cardNumber: "79927398713"))
        XCTAssertEqual(.validChecksum, validator.validate(cardNumber: "799 27398713"))
        XCTAssertEqual(.validChecksum, validator.validate(cardNumber: "799273 98713"))
        XCTAssertEqual(.validChecksum, validator.validate(cardNumber: "79927    398713"))
        XCTAssertEqual(.validChecksum, validator.validate(cardNumber: "79927 3 9 8 7 1\n3"))
        XCTAssertEqual(.validChecksum, validator.validate(cardNumber: "7 9 9 2  7 3  9 8 7 1  3"))
        XCTAssertEqual(.validChecksum, validator.validate(cardNumber: "799273987      1     \n\n3"))
    }
    
    func testInvalidCardNumberCharacters() {
        
        XCTAssertEqual(.invalidCharacters, validator.validate(cardNumber: "79927398713test"))
        XCTAssertEqual(.invalidCharacters, validator.validate(cardNumber: "a79927398713"))
        XCTAssertEqual(.invalidCharacters, validator.validate(cardNumber: "7 9 9    2  7  3 91 87a"))
        
    }
    
    func testInvalidCardNumberChecksum() {
        
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "79927398710"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "79927398711"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "79927398712"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "79927398714"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "79927398715"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "79927398716"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "79927398717"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "79927398718"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "79927398719"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "7992739871192"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "99927398713"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "89927398713"))
        XCTAssertEqual(.invalidChecksum, validator.validate(cardNumber: "7 9 9    2  7  3 91 8713"))
        
    }
}
