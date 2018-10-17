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

/// implementation of the BackendService protocol which does concrete HTTPs calls.
class HTTPBackendService: NSObject {
    /// private URLSession which is used for all heidelpay requests and which does Certificate Pinning
    private var session: URLSession {
        return URLSession(configuration: URLSessionConfiguration.ephemeral, delegate: self, delegateQueue: nil)
    }
    /// environment to be used by this backend service
    private let environment: Environment
    /// public key to be used for authorization by this backend service
    private let publicKey: PublicKey
    
    /// intialize the HTTPBackendService
    /// - Parameter publicKey: public key to be used for Authorization of requests
    /// - Parameter environment: environment to be used for all backend calls
    init(publicKey: PublicKey, environment: Environment) {
        self.publicKey = publicKey
        self.environment = environment
        
        super.init()
    }
    
    /// build a URLRequest object for the given backend request
    /// - Parameter heidelPayRequest: the request object that shall be encoded as URLRequest
    /// - Returns: URLRequest object of the encoded HeidelpayRequest
    /// - Throws: Error when the HeidelpayRequest could not be encoded
    func buildURLRequest(_ heidelPayRequest: HeidelpayRequest) throws -> URLRequest {
        let url = environment.URLForPath(heidelPayRequest.requestPath)
        var request = URLRequest(url: url)
        
        request.addValue(publicKey.authorizationHeaderValue, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let languageCode: String = Locale.current.languageCode ?? "en"
        request.addValue(languageCode, forHTTPHeaderField: "Accept-Language")
        
        if let dataRequest = heidelPayRequest as? HeidelpayDataRequest {
            let requestData = try dataRequest.encodeAsJSON()
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = requestData
            request.httpMethod = "POST"
            
        } else {
            
            request.httpMethod = "GET"
            
        }
        
        return request
    }
    
    /// analyze the received response and map it to a BackendError in case of a failure or a Data object
    /// in case of success
    /// - Parameter fromData: Data as received by the backend
    /// - Parameter response: HTTPURLResponse as received by the backend
    /// - Parameter response: Error object as received by the backend call
    /// - Returns: a tuple of data and backenderror. Only one of the two will be not nil.
    func buildResponse(fromData data: Data?, response: HTTPURLResponse?, error: Error?) -> (Data?, BackendError?) {
        if let error = error {

            let nsError = error as NSError
            
            if nsError.domain == NSURLErrorDomain, nsError.code == NSURLErrorNotConnectedToInternet {
                
                return (nil, .noInternet)
            } else {
                
                return (nil, .requestFailed(underlyingError: nsError))
            }
        }
        
        if let response = response, response.statusCode >= 400 {

            return (nil, .serverHTTPError(httpCode: response.statusCode))
            
        }
        
        if let data = data {

            // try to decode it as an error json object
            if let errorResponse = try? JSONDecoder().decode(BackendServerErrorResponse.self, from: data) {
                
                return (nil, .serverResponseError(errors: errorResponse.errors))
                
            }
        }
        
        return (data, nil)
    }
    
    /// internal method for executing an URLRequest
    /// - Parameter urlRequest: URLRequest to execute
    /// - Parameter completionHandler: Result of the method `buildResponse` after the task completed
    private func perform(urlRequest: URLRequest, completionHandler: @escaping ((Data?, BackendError?) -> Void)) {
        
        let task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
            guard let sSelf = self else {
                completionHandler(nil, nil)
                return
            }
            
            let response = sSelf.buildResponse(fromData: data, response: response as? HTTPURLResponse, error: error)
            completionHandler(response.0, response.1)
            
        }
        task.resume()
    }
        
}

/// implementation of the BackendService protocol
extension HTTPBackendService: BackendService {
    
    func perform(request: HeidelpayRequest, completionHandler: @escaping ((Any?, BackendError?) -> Void)) {
        
        let urlRequest: URLRequest
        do {
            urlRequest = try buildURLRequest(request)
        } catch {
            completionHandler(nil, .invalidRequest)
            return
        }
        
        perform(urlRequest: urlRequest) { (data, backendError) in
            if let data = data {
                do {
                    let response = try request.createResponse(fromData: data)
                    completionHandler(response, backendError)
                } catch {
                    completionHandler(nil, .invalidServerResponse)
                    return
                }
            } else {
                completionHandler(nil, backendError)
            }
        }
    }
}

/// Public Key Certificate Pinning
extension HTTPBackendService: URLSessionDelegate {
    
    private static let rsa2048Asn1Header: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // activate policies for host name check
        let policies = [ SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString) ]
        SecTrustSetPolicies(serverTrust, policies as AnyObject)
        
        // Evaluate the server certificate
        var evaluateResult = SecTrustResultType.invalid
        SecTrustEvaluate(serverTrust, &evaluateResult)
        
        var serverTrusted: Bool
        if evaluateResult == .unspecified || evaluateResult == .proceed {
            serverTrusted = true
        } else {
            serverTrusted = false
        }
        
        // shall we check the public key for the particular host?
        if serverTrusted && challenge.protectionSpace.host == environment.host {
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
            
            // compare the public key
            let policy = SecPolicyCreateBasicX509()
            
            var trust: SecTrust?
            SecTrustCreateWithCertificates([certificate] as CFArray, policy, &trust)
            
            let pubKey = SecTrustCopyPublicKey(trust!)
            
            var error: Unmanaged<CFError>?
            if let pubKeyData = SecKeyCopyExternalRepresentation(pubKey!, &error) {
                var keyWithHeader = Data(bytes: HTTPBackendService.rsa2048Asn1Header)
                keyWithHeader.append(pubKeyData as Data)
                let sha256Key = sha256(keyWithHeader)
                if !environment.pinnedPublicKeyHash.contains(sha256Key) {
                    serverTrusted = false
                }
            } else {
                serverTrusted = false
            }
        }
        
        if serverTrusted {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    /// calculate the sha356 for the given data by using the CommonCrypto library
    private func sha256(_ data: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(data.count), &hash)
        }
        return Data(bytes: hash).base64EncodedString()
    }
}
