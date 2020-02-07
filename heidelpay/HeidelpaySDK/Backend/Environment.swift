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

/// enumeration of the supported environments
enum Environment {
    
    /// Production system
    case production
    
    /// Host that environment
    public var host: String {
        return "api.heidelpay.com"
    }
    
    /// create an url for a given path
    func URLForPath(_ path: String) -> URL {
        let baseURL = URL(string: "https://\(host)/v1/")!
        return URL(string: path, relativeTo: baseURL)!
    }
    
    /// public key hash for certificate pinning
    var pinnedPublicKeyHash: String {
        switch self {
        case .production:
            // generate with the command certificatePinningPublicKeyHash.sh
            //
            // e.g. certificatePinningPublicKeyHash.sh api.heidelpay.com
            //
            return "QBOk6PGlUr8Xs8v+DNxHAsJc3Z746CtldyNII4tsEnw="
        }
    }
    
}
