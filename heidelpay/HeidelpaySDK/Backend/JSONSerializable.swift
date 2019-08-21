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

/// protocol for types that are serializable to JSON
protocol JSONSerializable {
    
    /// encode the element in JSON
    /// - Returns: encoded JSON String as UTF-8 data object
    /// - Throws: error when element can not be encoded as JSON
    func encodeAsJSON() throws -> Data
}

/// extension for internal use to encode as JSON
extension Encodable {
    
    /// encode the element in JSON
    /// - Returns: encoded JSON String as UTF-8 data object
    /// - Throws: error when element can not be encoded as JSON
    func encodeAsJSON() throws -> Data {
        let encoder = JSONEncoder()
        
        return try encoder.encode(self)
    }
    
}
