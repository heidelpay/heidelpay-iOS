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

/// Details of a received Server Error.
///
/// The messages are localized for the language configured in the
/// device settings and provided by the system (Foundation: `Locale.current`)
///
/// ## Note: The server may send more than one error for a request. In case there
/// is more than one error, the property addtionalErrorDetails holds the further errors.
public struct ServerErrorDetails {
    /// error code as defined by the Server API
    public let code: String
    /// user readable message (for internal use)
    public let merchantMessage: String
    /// user readable message for customer
    public let customerMessage: String
    
    /// additional errors send by the server for a particular request
    public let additionalErrorDetails: [ServerErrorDetails]?
    
    /// initializer with main error and optional additional errors
    /// - Parameter backendServerError: first error reported by the backend
    /// - Parameter additionalErrorDetails: additional errors reported by the backend and already mapped
    ///                                     as ServerErrorDetails elements
    init(backendServerError: BackendServerError, additionalErrorDetails: [ServerErrorDetails]? = nil) {
        self.code             = backendServerError.code
        self.merchantMessage  = backendServerError.merchantMessage
        self.customerMessage  = backendServerError.customerMessage
        self.additionalErrorDetails = additionalErrorDetails
    }
    
    /// maps the BackendServerError to the ServerErrorDetails structure
    /// - Parameter errors: array of backend errors
    /// - Returns: a ServerErrorDetails element with the data mapped from the first backend server error.
    ///            Additional backend server errors are mapped to the additionalErrorDetails property of
    ///            that element. This method returns nil in case there is no backend error element in the
    ///            provided array.
    static func createFromBackendServerErrors(_ errors: [BackendServerError]) -> ServerErrorDetails? {
        guard let firstError = errors.first else {
            return nil
        }
        
        var additionalErrorDetails: [ServerErrorDetails]?
        let additionalErrors = errors.dropFirst()
        if additionalErrors.count > 0 {
            additionalErrorDetails = additionalErrors.map({ ServerErrorDetails(backendServerError: $0) })
        }
        
        return ServerErrorDetails(backendServerError: firstError, additionalErrorDetails: additionalErrorDetails)
    }
}
