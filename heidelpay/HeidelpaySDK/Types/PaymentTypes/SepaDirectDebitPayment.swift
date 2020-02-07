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

/// Sepa Direct Debit Payment Type
/// There is a guaranteed and a non guaranteed version of the Sepa Direct Debit Payment type
/// which can be set as an additional constructor parameter. Default is non guaranteed.
struct SepaDirectDebitPayment: CreatePaymentType, Codable {
    
    /// dependent on the flag guaranteed the method is sepa direct debit guaranteed or not guaranteed
    var method: PaymentMethod {
        if guaranteed {
            return .sepaDirectDebitGuaranteed
        } else {
            return .sepaDirectDebit
        }
    }
    
    /// International bank account number (IBAN)
    let iban: String
    /// Bank identification number (only needed for some countries)
    let bic: String?
    /// Name of the bank account
    let holder: String?
    
    // explicit CodingKeys as the flag guaranteed is in client SDK only
    private enum CodingKeys: String, CodingKey {
        case iban, bic, holder
    }
    
    /// guaranteed flag
    private var guaranteed: Bool = false
    
    /// Init SepaDirectDebit Payment
    /// - Parameter iban: International bank account number (IBAN)
    /// - Parameter bic: Bank identification number (only needed for some countries) (optional)
    /// - Parameter holder: Name of the bank account (optional)
    /// - Parameter guaranteed: toggles if this is a guaranteed or non guaranteed sep direct payment.
    ///                         Default is non guaranteed.
    init(iban: String, bic: String?, holder: String?, guaranteed: Bool = false) {
        self.iban = iban
        self.bic = bic
        self.holder = holder
        
        self.guaranteed = guaranteed
    }
}
