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

/// Ideal Payment Type
struct IdealPayment: CreatePaymentType, Codable {
    var method: PaymentMethod { return .ideal }
    
    /// bic
    let bic: String
    
    /// initializer with bank name
    /// - Parameter bankName: bank name to use for this Ideal payment
    init(bic: String) {
        self.bic = bic
    }
}
