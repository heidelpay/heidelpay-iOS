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

/// Public key to authenticate against the heidelpay backend
public struct PublicKey {
    /// value of Authorization header for backend requests
    let authorizationHeaderValue: String

    /// create a public key out of a string
    /// - Parameter publicKey: public key of the merchant
    ///
    /// If the provided key is not in the correct format the
    /// application will end with a **fatal error**.
    ///
    /// ## Note:
    /// Use the `PublicKey.isPublicKey` function if you want to check if the key
    /// is in the correct format of a public key.
    public init(_ publicKey: String) {
        guard PublicKey.isPublicKey(publicKey) else {
            fatalError("You have to provide the public key")            
        }
        guard let authValueData = "\(publicKey):".data(using: .utf8) else {
            fatalError("Key has non UTF-8 characters")
        }
        authorizationHeaderValue = "Basic \(authValueData.base64EncodedString())"
    }

    /// verifies if the provided key has the expected public key format
    /// - Parameter key: key that shall be verified
    /// - Returns: true if the provided key is in the public key format
    public static func isPublicKey(_ key: String) -> Bool {
        // verify that the convertion to UTF8 succeeds. This conversion is
        // needed for the authorization header
        let isConvertibleToUTF8Data = key.data(using: .utf8) != nil
        return (key.hasPrefix("s-pub-") || key.hasPrefix("p-pub-")) && isConvertibleToUTF8Data
    }
    
}
