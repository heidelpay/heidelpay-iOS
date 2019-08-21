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
@testable import HeidelpaySDK

protocol MockedResponse {
    
}
struct MockedJSONResponse: MockedResponse {
    let json: String
}
struct MockedBackendErrorResponse: MockedResponse {
    let backendError: BackendError
    
    init(_ backendError: BackendError) {
        self.backendError = backendError
    }
}

class TestBackendService: BackendService {
    private var mockedPaths = [String: MockedResponse]()
    
    func mock(path: String, withResponse response: MockedResponse) {
        mockedPaths[path] = response
    }
    func mock(path: String, withJsonResponse jsonResponse: String) {
        mockedPaths[path] = MockedJSONResponse(json: jsonResponse)
    }
    
    func invalidate() {
        mockedPaths.removeAll()
    }
    
    func perform(request: HeidelpayRequest, completionHandler: @escaping ((Any?, BackendError?) -> Void)) {
        let path = request.requestPath
        
        guard let mockedResponse = mockedPaths[path] else {
            completionHandler(nil, BackendError.invalidRequest)
            return
        }
        
        do {
            
            switch mockedResponse {
            case let jsonResponse as MockedJSONResponse:
                let response = try request.createResponse(fromData: jsonResponse.json.data(using: .utf8)!)
                completionHandler(response, nil)
            case let errorResponse as MockedBackendErrorResponse:
                completionHandler(nil, errorResponse.backendError)
            default:
                completionHandler(nil, BackendError.invalidRequest)
            }
                        
        } catch {
            completionHandler(nil, BackendError.invalidServerResponse)
            return
        }
    }
    
}
