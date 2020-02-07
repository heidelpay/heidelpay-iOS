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

import Foundation

/// Credit Card Payment Type
struct CardPayment: CreatePaymentType, Codable {
    public var method: PaymentMethod { return .card }
    
    /// Creditcard number
    let number: String
    /// Creditcard Verification Code
    let cvc: String
    /// Expiry date in format MM/YY
    let expiryDate: String
    /// In case you have two contracts, one for 3DS and one without 3DS you can specify which one is
    /// the preferred one when using the card type during a charge
    let use3ds: Bool
    
    enum CodingKeys: String, CodingKey {
        case number
        case cvc
        case expiryDate
        case use3ds = "3ds"
    }
    
    /// initialize with basic checks (month in range, year in range, cvs length > 2, number length >= 15)
    /// if one of the check fails this initializer returns nil
    /// - Parameter number: Credit Card number
    /// - Parameter cvc: Card Validation Code (also named CVV)
    /// - Parameter expiryMonth: expiry month of the card
    /// - Parameter expiryYear: expiry year of the card
    /// - Parameter use3ds: flag to indicate if 3ds shall be used for this card on charge. (Depends on your contract).
    ///                     Default is true
    init?(number: String, cvc: String, expiryMonth: Int, expiryYear: Int, use3ds: Bool = true) {
        guard expiryMonth >= 1 && expiryMonth <= 12 else {
            return nil
        }
        var twoDigitExpiryYear = expiryYear
        if twoDigitExpiryYear > 2000 {
            twoDigitExpiryYear -= 2000
        }
        guard twoDigitExpiryYear > 0 && twoDigitExpiryYear < 100 else {
            return nil
        }
        guard cvc.count > 2 else {
            return nil
        }
        guard number.count >= 15 else {
            return nil
        }
        let month = String(format: "%02d", expiryMonth)
        
        self.init(number: number, cvc: cvc, expiryDate: "\(month)/\(twoDigitExpiryYear)", use3ds: use3ds)
    }
    
    /// private initializer with all fields of this type
    init(number: String, cvc: String, expiryDate: String, use3ds: Bool) {
        self.number = number
        self.cvc = cvc
        self.expiryDate = expiryDate
        self.use3ds = use3ds
    }
}
