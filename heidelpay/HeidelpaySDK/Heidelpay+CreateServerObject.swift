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

/// extension with methods for creating server side objects
extension Heidelpay {
    
    /// create a customer instance on the Heidelpay server
    /// - Parameter customer: a filled customer struct
    /// - Parameter completion: completion handler with server side customer id (success) or error object
    public func createCustomer(_ customer: Customer,
                               completion: @escaping ((_ customerId: String?, HeidelpayError?) -> Void)) {
                                
        performServerSideCreation(requestPath: "customers", dataObject: customer, completion: completion)
    }
    
    /// create a basket instance on the Heidelpay server
    /// - Parameter basket: a filled basket struct
    /// - Parameter completion: completion handler with server side basket id (success) or error object
    public func createBasket(_ basket: Basket,
                             completion: @escaping ((_ basketId: String?, HeidelpayError?) -> Void)) {

        performServerSideCreation(requestPath: "baskets", dataObject: basket, completion: completion)
    }
    
    private func performServerSideCreation<T: Encodable>(requestPath: String, dataObject: T,
                                                         completion: @escaping ((String?, HeidelpayError?) -> Void)) {
        
        let serverObjectRequest = CreateServerObjectRequest<T>(requestPath: requestPath, dataObject: dataObject)
        
        backendService.perform(request: serverObjectRequest) { (response, error) in
            
            if let serverObjectResponse = response as? CreateServerObjectResponse {
                
                execOnMain { completion(serverObjectResponse.id, nil) }
                
            } else if let error = error {
                           
               execOnMain { completion(nil, HeidelpayError.mapFrom(backendError: error)) }
               
            } else {
               
               execOnMain { completion(nil, .generalProcessingError) }
                          
            }
        }
    }
    
}
