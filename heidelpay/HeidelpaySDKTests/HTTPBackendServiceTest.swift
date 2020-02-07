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

struct TestRequestInputWithData: HeidelpayDataRequest, Codable {
    let requestPath = "testcall"
    
    let string: String
    let int: Int
    
    func createResponse(fromData: Data) throws -> Any {
        return "Test Response"
    }
}

struct TestRequestInputWithNoData: HeidelpayRequest, Codable {
    let requestPath = "testempty"
    
    func createResponse(fromData data: Data) throws -> Any {
        return try JSONDecoder().decode(TestResponse.self, from: data)        
    }
}

struct TestResponse: Codable {
    let stringOut: String
    let intOut: Int
    let arrayOut: [String]
}

class HTTPBackendServiceTest: XCTestCase {
    static let publicKey = PublicKey("s-pub-1234567890")
    static let authHeaderFromPK = "Basic cy1wdWItMTIzNDU2Nzg5MDo="
    
    var httpBackend: HTTPBackendService {
        return HTTPBackendService(publicKey: HTTPBackendServiceTest.publicKey, environment: .production)
    }
    
    func testBuildURLRequestWithData() {
        
        let requestData = TestRequestInputWithData(string: "abc", int: 123)
        let urlRequest: URLRequest
            
        do {
            urlRequest = try httpBackend.buildURLRequest(requestData)
        } catch {
            XCTFail("failed to create URLRequest")
            return
        }
        
        guard let url = urlRequest.url else {
            XCTFail("must not be nil")
            return
        }
        XCTAssertEqual(urlRequest.httpMethod, "POST")
        
        XCTAssertEqual(url.absoluteString, "https://api.heidelpay.com/v1/testcall")
        guard let authHeader = urlRequest.allHTTPHeaderFields?["Authorization"] else {
            XCTFail("must not be nil")
            return
        }
        XCTAssertEqual(authHeader, HTTPBackendServiceTest.authHeaderFromPK)
        
        guard let acceptHeader = urlRequest.allHTTPHeaderFields?["Accept"] else {
            XCTFail("must not be nil")
            return
        }
        XCTAssertEqual(acceptHeader, "application/json")
        
        guard let contentType = urlRequest.allHTTPHeaderFields?["Content-Type"] else {
            XCTFail("must not be nil")
            return
        }
        XCTAssertEqual(contentType, "application/json")
        
        guard let content = urlRequest.httpBody else {
            XCTFail("must not be nil")
            return
        }
        guard let json = try? JSONSerialization.jsonObject(with: content, options: []) else {
            XCTFail("must not be nil")
            return
        }
        
        guard let jsonDict = json as? [String: Any] else {
            XCTFail("should be a dictionary")
            return
        }
        
        XCTAssertEqual(jsonDict["string"] as? String, "abc")
        XCTAssertEqual(jsonDict["int"] as? Int, 123)
    }
    
    func testBuildURLRequestWithNoData() {
        let requestData = TestRequestInputWithNoData()
        let urlRequest: URLRequest
        
        do {
            urlRequest = try httpBackend.buildURLRequest(requestData)
        } catch {
            XCTFail("failed to create URLRequest")
            return
        }
        XCTAssertEqual(urlRequest.httpMethod, "GET")        
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Accept-Language"], Locale.current.languageCode)
        
        XCTAssertNil(urlRequest.allHTTPHeaderFields?["Content-Type"])
        XCTAssertNil(urlRequest.httpBody)
    }
    
    func testBuildResponse() {
        let responseString = """
        {
            "stringOut" : "abcdef",
            "intOut": 123,
            "arrayOut": [ "abc", "def", "ghi" ]
        }
"""
        let responseData = responseString.data(using: .utf8)!
        let testRequest = TestRequestInputWithNoData()
        
        do {
            guard let response = try testRequest.createResponse(fromData: responseData) as? TestResponse else {
                XCTFail("Response is not of the correct type")
                return
            }
            XCTAssertEqual(response.stringOut, "abcdef")
            XCTAssertEqual(response.intOut, 123)
            XCTAssertEqual(response.arrayOut.count, 3)
            
        } catch {
            XCTFail("decode of response shall succeed")
        }
    }
    
    func testBuildResponseNoInternet() {
        
        let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let response = httpBackend.buildResponse(fromData: nil, response: nil, error: error)
        
        XCTAssertNil(response.0)
        XCTAssertNotNil(response.1)
        XCTAssertEqual(response.1!, BackendError.noInternet)
        
    }
    
    func testBuildResponseFromHttpCode4xx() {
        
        let httpResponse = HTTPURLResponse(url: URL(string: "https://api.heidelpay.com")!,
                                           statusCode: 400, httpVersion: nil, headerFields: nil)
        let response = httpBackend.buildResponse(fromData: nil, response: httpResponse, error: nil)
        
        XCTAssertNil(response.0)
        XCTAssertNotNil(response.1)
        if case let .serverHTTPError(httpCode) = response.1! {
            XCTAssertEqual(httpCode, 400)
        } else {
            XCTFail("wrong error")
        }
    }
    
    func testBuildResponseFromServerErrorJSON() {
        let errorResponse = """
{
    "url" : "https://api.heidelpay.com/v1/keypair",
    "timestamp" : "2018-09-20 09:27:58",
    "errors" : [ {
        "code" : "API.000.000.002",
        "merchantMessage" : "The given key s-pub-2a10ifVINFAjpQJ9qW8jBe5OJPBx6Gxaas is unknown or invalid.",
        "customerMessage" : "There was a problem authenticating your request.Please contact us for more information."
    } ]
}
"""
        let data = errorResponse.data(using: .utf8)
        
        let response = httpBackend.buildResponse(fromData: data, response: nil, error: nil)
        
        XCTAssertNil(response.0)
        XCTAssertNotNil(response.1)
        if case let .serverResponseError(errors) = response.1! {
            XCTAssertEqual(errors.count, 1)
            XCTAssertEqual(errors[0].code, "API.000.000.002")
            XCTAssertNotNil(errors[0].merchantMessage)
            XCTAssertNotNil(errors[0].customerMessage)
        } else {
            XCTFail("wrong error")
        }
    }
    
}
