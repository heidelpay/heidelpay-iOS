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


import UIKit

/// Extension for providing additional methods on PaymentMethod
public extension PaymentMethod {

    /// Returns an appropriate image to be used for this PaymentMethod or nil if an appropriate image is not available
    var icon: UIImage? {
        switch self {
        case .card:
            return UIImage.heidelpay_resourceImage(named: "card")
        case .sepaDirectDebit, .sepaDirectDebitGuaranteed:
            return UIImage.heidelpay_resourceImage(named: "sepa")
        case .paypal:
            return UIImage.heidelpay_resourceImage(named: "paypal")
        case .sofort:
            return UIImage.heidelpay_resourceImage(named: "sofort")
        case .invoice:
            return UIImage.heidelpay_resourceImage(named: "invoice")
        case .invoiceGuaranteed:
            return UIImage.heidelpay_resourceImage(named: "invoice-guaranteed")
        case .giropay:
            return UIImage.heidelpay_resourceImage(named: "giropay")
        case .prepayment:
            return UIImage.heidelpay_resourceImage(named: "prepayment")
        case .przelewy24:
            return UIImage.heidelpay_resourceImage(named: "przelewy-24")
        case .ideal:
            return UIImage.heidelpay_resourceImage(named: "ideal")
        case .applepay:
            return UIImage.heidelpay_resourceImage(named: "apple-pay")
        }
    }
    
    /// printable name of the Payment Method
    var displayName: String {
        switch self {
        case .card: return "Card"
        case .sepaDirectDebit: return "Sepa Direct Debit"
        case .sepaDirectDebitGuaranteed: return "Sepa Direct Debit Guaranteed"
        case .paypal: return "PayPal"
        case .sofort: return "Sofortüberweisung"
        case .giropay: return "Giropay"
        case .invoiceGuaranteed: return "Invoice Guaranteed"
        case .invoice: return "Invoice"
        case .prepayment: return "Prepayment"
        case .przelewy24: return "Przelewy24"
        case .ideal: return "iDEAL"
        case .applepay: return "Apple Pay"            
        }
    }
    
    /// indicates if there might be multiple Payment Type instances of that payment method
    /// for a single customer
    var multipleInstancesAllowed: Bool {
        switch self {
        case .card, .sepaDirectDebit, .sepaDirectDebitGuaranteed, .ideal:
            return true
        default:
            return false
        }
    }

}
