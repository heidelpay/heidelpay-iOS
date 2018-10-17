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


import Foundation

/// Invoice Payment Type
/// There is a guaranteed and a non guaranteed version of the Invoice Payment type
/// which can be set as an additional constructor parameter. Default is non guaranteed.
public struct InvoicePayment: CreatePaymentType, Codable {
    
    /// dependent on the flag guaranteed the method is invoice guaranteed or not guaranteed
    var method: PaymentMethod {
        if guaranteed {
            return .invoiceGuaranteed
        } else {
            return .invoice
        }
    }
    
    // explicit CodingKeys as the flag guaranteed is in client SDK only
    private enum CodingKeys: CodingKey {     
    }
    
    /// guaranteed flag
    private var guaranteed: Bool = false
    
    /// Init Invoice Payment which has no data parameter
    /// - Parameter guaranteed: toggles if this is a guaranteed or non guaranteed invoice payment.
    ///                         Default is non guaranteed.
    init(guaranteed: Bool = false) {
        self.guaranteed = guaranteed
    }
}
