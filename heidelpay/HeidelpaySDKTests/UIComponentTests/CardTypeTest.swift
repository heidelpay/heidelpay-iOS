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

class CardTypeTest: XCTestCase {
    
    func testCardFromBrand() {
        
        XCTAssertEqual(CardType(brandName: "VISA"), .visa)
        XCTAssertEqual(CardType(brandName: "MASTER"), .masterCard)
        
    }
    
    func testCardTypesForNumber() {
        XCTAssertEqual(CardType.unknown, CardType(cardNumber: "1234"))
        XCTAssertEqual(CardType.masterCard, CardType(cardNumber: "2345"))
        XCTAssertEqual(CardType.americanExpress, CardType(cardNumber: "3456"))
        XCTAssertEqual(CardType.visa, CardType(cardNumber: "4567"))
        XCTAssertEqual(CardType.masterCard, CardType(cardNumber: "5678"))
        XCTAssertEqual(CardType.maestro, CardType(cardNumber: "6789"))
        XCTAssertEqual(CardType.maestro, CardType(cardNumber: "7890"))
        XCTAssertEqual(CardType.unknown, CardType(cardNumber: "8901"))
        XCTAssertEqual(CardType.maestro, CardType(cardNumber: "9012"))
        XCTAssertEqual(CardType.unknown, CardType(cardNumber: "0123"))
        
        XCTAssertEqual(CardType.unknown, CardType(cardNumber: "a123"))
    }
    
    func testGrouping() {
        let unknown = CardType.unknown
        XCTAssertEqual(16, unknown.minimumLength)
        XCTAssertEqual(16, unknown.maximumLength)
        XCTAssertEqual(GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 16),
                       unknown.groupingMode)
        
        let visa = CardType.visa
        XCTAssertEqual(16, visa.minimumLength)
        XCTAssertEqual(16, visa.maximumLength)
        XCTAssertEqual(GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 16),
                       visa.groupingMode)
        
        let amex = CardType.americanExpress
        XCTAssertEqual(15, amex.minimumLength)
        XCTAssertEqual(15, amex.maximumLength)
        XCTAssertEqual(GroupingStyle.variableGroups(groupSizes: [4, 6, 5], maximumLength: 15),
                       amex.groupingMode)
        
        let masterCard = CardType.masterCard
        XCTAssertEqual(16, masterCard.minimumLength)
        XCTAssertEqual(16, masterCard.maximumLength)
        XCTAssertEqual(GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 16),
                       masterCard.groupingMode)
        
        let maestro = CardType.maestro
        XCTAssertEqual(12, maestro.minimumLength)
        XCTAssertEqual(19, maestro.maximumLength)
        XCTAssertEqual(GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 19),
                       maestro.groupingMode)
    }
    
    func testAmexValidation() {
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidLength,
                       CardType.americanExpress.validate(cardNumber: "37035549687"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.validChecksum,
                       CardType.americanExpress.validate(cardNumber: "370355496876137"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.validChecksum,
                       CardType.americanExpress.validate(cardNumber: "37 03554968 76  \n137 "))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidChecksum,
                       CardType.americanExpress.validate(cardNumber: "380355496876137"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidLength,
                       CardType.americanExpress.validate(cardNumber: "3703554968761377"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidChecksum,
                       CardType.americanExpress.validate(cardNumber: "370355496876138"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidCharacters,
                       CardType.americanExpress.validate(cardNumber: "37035549687613a"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidCharacters,
                       CardType.americanExpress.validate(cardNumber: "3703554968 7613  a"))
    }
    
    func testMasterCardValidation() {
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidLength,
                       CardType.masterCard.validate(cardNumber: "538950124765"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.validChecksum,
                       CardType.masterCard.validate(cardNumber: "5389501247653501"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.validChecksum,
                       CardType.masterCard.validate(cardNumber: "5389  501247653  50 \n\n1"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidChecksum,
                       CardType.masterCard.validate(cardNumber: "5489501247653501"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidLength,
                       CardType.masterCard.validate(cardNumber: "5389501247653501123"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidChecksum,
                       CardType.masterCard.validate(cardNumber: "5389501247653502"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidCharacters,
                       CardType.masterCard.validate(cardNumber: "538950124765350a"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidCharacters,
                       CardType.masterCard.validate(cardNumber: "53895012476  5 b5  e1"))
    }
    
    func testVisaValidation() {
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidLength,
                       CardType.visa.validate(cardNumber: "4539260780952"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.validChecksum,
                       CardType.visa.validate(cardNumber: "4539260780952497"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.validChecksum,
                       CardType.visa.validate(cardNumber: "45  3926 07 809  52497"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidChecksum,
                       CardType.visa.validate(cardNumber: "4639260780952497"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidLength,
                       CardType.visa.validate(cardNumber: "4539260780952497123"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidChecksum,
                       CardType.visa.validate(cardNumber: "4539260780952498"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidCharacters,
                       CardType.visa.validate(cardNumber: "453926078095249a"))
        XCTAssertEqual(PaymentTypeInformationValidationResult.invalidCharacters,
                       CardType.visa.validate(cardNumber: "453 a260780952   \nb97"))
    }
}
