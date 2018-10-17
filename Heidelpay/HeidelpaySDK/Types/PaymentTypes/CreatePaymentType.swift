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

/// PaymentType protocol implemented by all concrete payment types like CardPayment for creation
protocol CreatePaymentType {
    /// payment method of that payment type
    var method: PaymentMethod { get }
    
    /// create a PaymentType
    /// - Parameter paymentId: id of the Payment Type created
    /// - Parameter paymentMethod: method of the Payment Type created
    /// - Parameter json: additional data parameters provided by the backend
    /// - Returns: a PaymentType element
    func paymentType(paymentId: String, paymentMethod: PaymentMethod, json: [String: Any]) -> PaymentType
}

/// default implementation of the paymentType creation method
extension CreatePaymentType {
    
    func paymentType(paymentId: String, paymentMethod: PaymentMethod, json: [String: Any]) -> PaymentType {
        
        return PaymentType(paymentId: paymentId, paymentMethod: paymentMethod, title: method.rawValue, data: json)
        
    }
}
