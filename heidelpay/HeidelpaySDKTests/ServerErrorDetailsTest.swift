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

import XCTest
@testable import HeidelpaySDK

class ServerErrorDetailsTest: XCTestCase {

    func testNoElementMapping() {
        XCTAssertNil(ServerErrorDetails.createFromBackendServerErrors([]))
    }
    
    func testSingleElementMapping() {
        
        let errorDetails = ServerErrorDetails.createFromBackendServerErrors([
            BackendServerError(code: "123", merchantMessage: "merchant", customerMessage: "customer")
            ])
        XCTAssertEqual(errorDetails?.code, "123")
        XCTAssertEqual(errorDetails?.merchantMessage, "merchant")
        XCTAssertEqual(errorDetails?.customerMessage, "customer")
        
    }

    func testMultipleElementMapping() {
        
        let errorDetails = ServerErrorDetails.createFromBackendServerErrors([
            BackendServerError(code: "123", merchantMessage: "merchant", customerMessage: "customer"),
            BackendServerError(code: "sub1-123", merchantMessage: "sub1-merchant", customerMessage: "sub1-customer"),
            BackendServerError(code: "sub2-123", merchantMessage: "sub2-merchant", customerMessage: "sub2-customer")
            ])
        XCTAssertEqual(errorDetails?.code, "123")
        XCTAssertEqual(errorDetails?.merchantMessage, "merchant")
        XCTAssertEqual(errorDetails?.customerMessage, "customer")
        XCTAssertEqual(errorDetails?.additionalErrorDetails?.count, 2)
        
        XCTAssertEqual(errorDetails?.additionalErrorDetails?[0].code, "sub1-123")
        XCTAssertEqual(errorDetails?.additionalErrorDetails?[0].merchantMessage, "sub1-merchant")
        XCTAssertEqual(errorDetails?.additionalErrorDetails?[0].customerMessage, "sub1-customer")

        XCTAssertEqual(errorDetails?.additionalErrorDetails?[1].code, "sub2-123")
        XCTAssertEqual(errorDetails?.additionalErrorDetails?[1].merchantMessage, "sub2-merchant")
        XCTAssertEqual(errorDetails?.additionalErrorDetails?[1].customerMessage, "sub2-customer")
    }
}
