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

/// Intial request to verify the public key
struct SetupRequest: HeidelpayRequest {
    /// request path for the setup request
    var requestPath = "keypair"
    
    /// 
    func createResponse(fromData data: Data) throws -> Any {
        return try JSONDecoder().decode(SetupResponse.self, from: data)
    }
    
}

struct SetupResponse: Codable {
    let availablePaymentTypes: [String]
    
    /// maps the received available payment methods to the ones which
    /// are supported by this version of the SDK
    func mappedPaymentMethods() -> [PaymentMethod] {
        
        return availablePaymentTypes.compactMap { PaymentMethod(rawValue: $0) }
        
    }
}
