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

// simple payment types with no data parameter

/// Sofort Ueberweisung Payment Type
struct SofortPayment: CreatePaymentType, Codable {
    var method: PaymentMethod { return .sofort }
}

/// Giropay Payment Type
struct GiropayPayment: CreatePaymentType, Codable {
    var method: PaymentMethod { return .giropay }
}

/// Prepayment Payment Type
struct PrepaymentPayment: CreatePaymentType, Codable {
    var method: PaymentMethod { return .prepayment }
}

/// Przelewy24 Payment Type
struct Przelewy24Payment: CreatePaymentType, Codable {
    var method: PaymentMethod { return .przelewy24 }
}

/// Paypal Payment Type
struct PaypalPayment: CreatePaymentType, Codable {
    var method: PaymentMethod { return .paypal }
}
