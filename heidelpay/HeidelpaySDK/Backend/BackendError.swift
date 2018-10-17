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

/// enumeration of errors from the Backend Service
enum BackendError: Error {
    /// the request data or url is invalid and an URLRequest can't be created
    case invalidRequest
    
    /// the server data are in a format that wasn't expected
    case invalidServerResponse
    
    /// the system reported that there is no connection to the internet
    case noInternet
    
    /// request failed on a system level. server may not be reached at all
    case requestFailed(underlyingError: NSError)
    
    /// the server was reached and responded with a HTTP error code >= 400
    case serverHTTPError(httpCode: Int)
    
    /// the server was reached and responded with a JSON error object which was parsed
    /// and the concrete error information is provided as an arry of type ServerError
    case serverResponseError(errors: [BackendServerError])
}

/// Equatable implementation for the BackendError enum
extension BackendError: Equatable {
    static func == (lhs: BackendError, rhs: BackendError) -> Bool {
        switch (lhs, rhs) {
            
        case (.invalidRequest, .invalidRequest),
             (.invalidServerResponse, .invalidServerResponse),
             (.noInternet, .noInternet):
             return true

        case let (.requestFailed(lhsError), .requestFailed(rhsError)):
            return lhsError == rhsError

        case let (.serverHTTPError(lhsError), .serverHTTPError(rhsError)):
            return lhsError == rhsError

        case let (.serverResponseError(lhsErrors), .serverResponseError(rhsErrors)):
            return lhsErrors == rhsErrors
        
        default:
            return false
        }
    }
}

// type used to decode the error json of the server
struct BackendServerError: Codable, Equatable {
    let code: String
    let merchantMessage: String
    let customerMessage: String
}

// type used to decode the error json of the server
struct BackendServerErrorResponse: Codable {
    let url: String
    let timestamp: String
    let errors: [BackendServerError]
}
