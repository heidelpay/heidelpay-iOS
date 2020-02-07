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
import os.log

/// execute the given block on the main thread
func execOnMain(_ block: @escaping (() -> Void)) {
    DispatchQueue.main.async {
        block()
    }
}

/// Entry class of the heidelpay SDK
///
/// The heidelpay element allows you to create payment types in a secure way.
///
/// In order to use the heidelpay system you have to setup an instance with the
/// PublicKey that is provided to you bei heidelpay.
///
/// An initialized instance is stored and available through the sharedInstance property of
/// the heidelpay class.
///
/// ## Note:
/// For security reasons the private key must not be used on the client side.
/// The private key must kept private on your server side.
public class Heidelpay {
    /// definition of the completion block which is called after setup completed
    ///
    /// When setup succeeded the completion handler is called with a heidelpay
    /// instance as the first parameter and nil for the second parameter.
    /// In case of an error the first parameter is nil and the second parameter
    /// holds an error object of type HeidelpayError.
    public typealias SetupCompletionBlock = ((Heidelpay?, HeidelpayError?) -> Void)
    
    /// definition of the completion block which is called after a payment type create request completed
    ///
    /// When creation succeeded the first parameter holds a `PaymentTypeId` element which references
    /// the newly created payment type. The information of this payment type id can be used on your
    /// server part to trigger a charge.
    ///
    /// In case of an error the first parameter is nil and the second parameter holds an error object
    /// with more details about the problem.
    ///
    /// It is guaranteed that only one of the two parameters is nil
    public typealias CreatePaymentCompletionBlock = ((PaymentType?, HeidelpayError?) -> Void)
    
    /// enumeration of errors that may occur during setup or creation of payment types
    public enum HeidelpayError: Error {
        /// the server could not be reached because there seems to be no internet connection
        case noInternetConnection
        
        /// the request failed because of a technical issue. please contact support
        case generalProcessingError
        
        /// the provided key is not authorized to use the heidelpay service
        case notAuthorized
        
        /// the server reported an error
        case serverError(details: ServerErrorDetails)
    }
    
    /// SDK version (Bundle Version)
    public static var sdkVersion: String = {
        
        let bundle = Bundle.init(for: Heidelpay.self)
        guard let versionString = bundle.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "?"
        }
        return versionString
    }()
    
    /// backend service used by this instance
    let backendService: BackendService
    
    /// available payment methods supported by the SDK and provided by the heidelpay backend
    public let paymentMethods: [PaymentMethod]
    
    private init(backendService: BackendService, paymentMethods: [PaymentMethod]) {
        self.backendService = backendService
        self.paymentMethods = paymentMethods        
    }
    
    deinit {
        backendService.invalidate()
    }
    
    /// create a new payment type
    /// - Parameter type: Payment Type to create
    /// - Parameter completion: CreatePaymentCompletionBlock  that will be called in failure and success.
    ///
    /// The completion block is either called with a PaymentTypeId element which references the created
    /// payment type or with an error. It's guaranteed that only one of the two parameters is not nil.
    ///
    func createPayment(type: CreatePaymentType, completion: @escaping CreatePaymentCompletionBlock) {
        
        backendService.perform(request: CreatePaymentTypeRequest(type: type)) { (response, error) in
            if let paymentType = response as? PaymentType {
                
                execOnMain { completion(paymentType, nil) }
                
            } else if let error = error {
                
                execOnMain { completion(nil, HeidelpayError.mapFrom(backendError: error)) }
                
            } else {
                
                execOnMain { completion(nil, .generalProcessingError) }
                           
            }
        }
    }
    
    /// setup a heidelpay instance
    /// - Parameter: publicKey the public key of the merchant
    /// - Parameter: completion completion block that will be called in failure and success.
    ///
    /// The completion block is called with a heidelpay instance if setup succeeded. The
    /// second parameter is nil.
    /// In case of an error the first parameter is nil and the second parameter holds an
    /// element of type HeidelpayError. It's guaranteed that only one of the two parameter is nil.
    ///
    public static func setup(publicKey: PublicKey, completion: @escaping SetupCompletionBlock) {
        let backendService = backendServiceCreator(publicKey, Environment.production)
        
        backendService.perform(request: SetupRequest()) { (response, error) in
            
            if let setupResponse = response as? SetupResponse {
                let paymentMethods = setupResponse.mappedPaymentMethods()
                let heidelPay = Heidelpay(backendService: backendService, paymentMethods: paymentMethods)
                
                execOnMain {
                    completion(heidelPay, nil)
                }
                
            } else if let error = error {
                
                backendService.invalidate()
                
                execOnMain {
                    completion(nil, HeidelpayError.mapFrom(backendError: error))
                }
                
            } else {
                
                backendService.invalidate()
                
                execOnMain {
                    completion(nil, .generalProcessingError)
                }
                
            }
        }
        
    }
    
    /// helper method for unit testing to mock the backend service
    static var backendServiceCreator: ((PublicKey, Environment) -> BackendService) = { (publicKey, environment)  in
        return HTTPBackendService(publicKey: publicKey, environment: environment)
    }
    
}

/// extension for mapping of BackendError to HeidelpayError
extension Heidelpay.HeidelpayError {
    /// map a BackendError to a HeidelpayError
    static func mapFrom(backendError: BackendError) -> Heidelpay.HeidelpayError {
        switch backendError {
            
        case .invalidRequest,
             .invalidServerResponse,
             .requestFailed:
            
            return .generalProcessingError
            
        case .instanceInvalidated:
            
            let log = OSLog(subsystem: "com.heidelpay.HeidelpaySDK", category: "sdk")
            os_log("failure: instance has been invalidated. You must keep a strong reference to the Heidelpay instance",
                   log: log, type: .error)
                        
            return .generalProcessingError
            
        case .noInternet:
            return .noInternetConnection
            
        case .serverHTTPError(let httpCode):
            switch httpCode {
            case 401, 403:
                return .notAuthorized
            default:
                return .generalProcessingError
            }
            
        case .serverResponseError(let errors):
            if let serverErrorDetails = ServerErrorDetails.createFromBackendServerErrors(errors) {
                
                return .serverError(details: serverErrorDetails)
                
            } else {
                
                return .generalProcessingError
                
            }
        }
    }
}
