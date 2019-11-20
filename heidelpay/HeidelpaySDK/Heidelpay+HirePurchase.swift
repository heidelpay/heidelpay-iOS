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

/// extension with methods specific to HirePurchase payment type
extension Heidelpay {

    /// retrieve the available plans for hire purchase
    /// - Parameter amount: specifies the total amount to be paid in monthly installments
    /// - Parameter currencyCode: currency code in which the installments will be paid (e.g. EUR)
    /// - Parameter effectiveInterest: effective interest rate of the monthly installment payments.
    ///                                The range is tied to your merchant configuration.
    /// - Parameter orderDate: optional order date
    /// - Parameter completion: handler that is called in success and failure case
    public func retrieveHirePurchasePlans(amount: Float,
                                          currencyCode: String,
                                          effectiveInterest: Float,
                                          orderDate: Date?=nil,
                                          completion: @escaping (Result<[HirePurchasePlan], HeidelpayError>) -> Void) {
        
        let request = RetrieveHirePurchasePlansRequest(amount: amount,
                                                       currencyCode: currencyCode,
                                                       effectiveInterest: effectiveInterest,
                                                       orderDate: orderDate)
        backendService.perform(request: request) { (data, error) in
            
            if let response = data as? RetrieveHirePurchasePlansResponse {
                
                if let plans = response.entity {
                    
                    completion(.success(plans))
                    
                } else {
                    
                    completion(.failure(.generalProcessingError))
                    
                }
                
            } else if let error = error {
                
                completion(.failure(HeidelpayError.mapFrom(backendError: error)))
                
            } else {
                
                completion(.failure(.generalProcessingError))
                
            }            
        }
    }
    
    /// create a Hire Purchase payment type
    /// - Parameter iban: International bank account number (IBAN)
    /// - Parameter bic: Bank identification number (only needed for some countries)
    /// - Parameter holder: Name of the bank account
    /// - Parameter plan: Hire purchase plan
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentHirePurchase(iban: String, bic: String, holder: String,
                                          plan: HirePurchasePlan,
                                          completion: @escaping CreatePaymentCompletionBlock) {
        
        createPayment(type: HirePurchasePayment(iban: iban, bic: bic, holder: holder, plan: plan),
                      completion: completion)
    }
}
