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

/// heidelpay backend request for creating Payment Types
///
/// As the Backend scheme for creating payment types is the same for all different
/// kind of payment types this class is capable to create payment types for
/// all supported payment methods.
struct CreatePaymentTypeRequest: HeidelpayDataRequest {
    /// request path which depends on the payment method to be created
    var requestPath: String {
        return "types/\(type.method.createPaymentTypeBackendPath)"
    }
    /// payment type that shall be created
    private let type: CreatePaymentType
    
    /// standard initializer
    init(type: CreatePaymentType) {
        self.type = type
    }
    
    func encodeAsJSON() throws -> Data {
        if let codableType = type as? Encodable {
            return try codableType.encodeAsJSON()
        }
        if let jsonSerializationType = type as? JSONSerializable {
            return try jsonSerializationType.encodeAsJSON()
        }
        throw BackendError.invalidRequest
    }
    
    func createResponse(fromData data: Data) throws -> Any {
        let response = try JSONDecoder().decode(CreatePaymentTypeResponse.self, from: data)
        guard let method = PaymentMethod(rawValue: response.method) else {
            throw BackendError.invalidServerResponse
        }
        let json: [String: Any]
        if var jsonBackend = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            // remove data that is already mapped by CreatePaymentTypeResponse
            jsonBackend["id"] = nil
            jsonBackend["method"] = nil
            json = jsonBackend
        } else {
            json = [:]
        }
        return type.paymentType(paymentId: response.id, paymentMethod: method, json: json)
    }
}

/// helper type to map the server side JSON to the SDK
/// element PaymentTypeId
private struct CreatePaymentTypeResponse: Codable {
    // swiftlint:disable identifier_name
    /// id of the created payment type
    let id: String
    /// payment method of the created payment type
    let method: String
}
