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

import XCTest
@testable import HeidelpaySDK

class PublicKeyTest: XCTestCase {

    func testCreate() {
        
        let key = PublicKey("s-pub-1234567890")
        XCTAssertEqual(key.authorizationHeaderValue, "Basic cy1wdWItMTIzNDU2Nzg5MDo=")
        
    }
    
    func testVerifyKey() {
        
        XCTAssertTrue(PublicKey.isPublicKey("s-pub-1234567890"))
        XCTAssertTrue(PublicKey.isPublicKey("p-pub-1234567890"))
        
        XCTAssertFalse(PublicKey.isPublicKey("s-PUB-1234567890"))
        XCTAssertFalse(PublicKey.isPublicKey("S-PUB-1234567890"))
        XCTAssertFalse(PublicKey.isPublicKey("s-pub1234567890"))
        
        XCTAssertFalse(PublicKey.isPublicKey("s-priv-1234567890"))
        XCTAssertFalse(PublicKey.isPublicKey("s-what-1234567890"))
        XCTAssertFalse(PublicKey.isPublicKey("s-Non-1234567890"))
        
    }

}
