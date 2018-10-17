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

/// enumeration of payment methods supported by the version of the SDK
public enum PaymentMethod: String {
    
    /// credit card payment
    case card
    
    /// sofort ueberweisung
    case sofort
    
    /// sepa direct debit
    case sepaDirectDebit = "sepa-direct-debit"
    
    /// sepa direct debit guaranteed
    case sepaDirectDebitGuaranteed = "sepa-direct-debit-guaranteed"
    
    /// invoice
    case invoice
    
    /// invoice guaranteed
    case invoiceGuaranteed = "invoice-guaranteed"
    
    /// giropay
    case giropay
    
    /// prepayment
    case prepayment
    
    /// przelewy24
    case przelewy24
    
    /// paypal
    case paypal
    
    /// ideal
    case ideal
}
