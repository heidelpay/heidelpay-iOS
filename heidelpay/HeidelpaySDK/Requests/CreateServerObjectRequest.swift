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

/// request to create a server side object with an id as response
/// e.g. customer or basket
struct CreateServerObjectRequest<T: Encodable>: HeidelpayDataRequest {

    /// request path for the request
    var requestPath: String
    
    /// dataObject for creation
    let dataObject: T
    
    init(requestPath: String, dataObject: T) {
        self.requestPath = requestPath
        self.dataObject = dataObject
    }
    
    func encodeAsJSON() throws -> Data {
        return try JSONEncoder().encode(self.dataObject)
    }
        
    func createResponse(fromData data: Data) throws -> Any {
        return try JSONDecoder().decode(CreateServerObjectResponse.self, from: data)
    }
    
}

// swiftlint:disable identifier_name
struct CreateServerObjectResponse: Codable {
    let id: String    
}
