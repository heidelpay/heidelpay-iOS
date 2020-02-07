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

extension SepaDirectDebitPayment {
    func paymentType(paymentId: String, paymentMethod: PaymentMethod, json: [String: Any]) -> PaymentType {
        let data = [
            "iban": iban
        ]
        return PaymentType(paymentId: paymentId, paymentMethod: paymentMethod, title: method.rawValue, data: data)
    }
}

extension IdealPayment {
    func paymentType(paymentId: String, paymentMethod: PaymentMethod, json: [String: Any]) -> PaymentType {
        let data = [
            "bic": bic
        ]
        return PaymentType(paymentId: paymentId, paymentMethod: paymentMethod, title: method.rawValue, data: data)
    }
}
