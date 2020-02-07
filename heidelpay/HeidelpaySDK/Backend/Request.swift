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

/// Protocol implemented by all heidelpay backend request types that don't
/// send data to the backend (request body is empty)
protocol HeidelpayRequest {
    /// request path of the request
    var requestPath: String { get }
    
    /// convert the received data to a response object that belongs to that request
    /// e.g. a User request would map to a User object
    /// - Parameter fromData: Data received from the backend
    /// - Returns: Response object if successful
    /// - Throws: error when mapping of received data to response type is not possible
    func createResponse(fromData: Data) throws -> Any
}

/// Protocol implemented by all heidelpay backend request tyeps that send JSON
/// data with the request
protocol HeidelpayDataRequest: HeidelpayRequest {
    /// encode the request data in JSON
    /// - Returns: encoded JSON String as UTF-8 data object
    /// - Throws: error when request data can not be encoded as JSON
    func encodeAsJSON() throws -> Data
}

/// Error Response type for decoding the server error JSON
struct HeidelpayErrorResponse: Codable {
    /// the url of the request that lead to this error response
    let url: String
    /// the timestamp of the request
    let timestamp: String
    /// error details returned by the server
    let errors: [HeidelpayBackendError]
}

/// Backend Error details as part of the server error JSON
/// see also `HeidelpayErrorResponse`
struct HeidelpayBackendError: Codable {
    /// error code as defined by the heidelpay backend
    let code: String
    /// a message for the merchant about the error
    let merchantMessage: String
    /// an error message for the customer. This message is localized
    /// based on the current Locale of the users device
    /// The localized message is returned by the heidelpay server.
    let customerMessage: String
}
