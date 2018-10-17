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

/// A customer Payment Type which can be used for a charge (on the server side)
public struct PaymentType {
    /// payment id which will be used for the charge on the server side
    public let paymentId: String
    /// payment method of that payment type
    public let method: PaymentMethod
    /// a user printable value of that payment type
    public let title: String
    /// data parameters specific to this payment type and payment method
    /// e.g. a credit card type has a data paremeter "brand" which holds
    /// the brand of the card. The names of these parameter match the name
    /// of the parameters of the server request to create a payment type
    public let data: [String: Any]?
    
    /// standard initializer for all properties
    init(paymentId: String, paymentMethod: PaymentMethod, title: String, data: [String: Any]?) {
        self.paymentId = paymentId
        self.method = paymentMethod
        self.title = title        
        self.data = data
    }
    
    /// map an array of dictionary from a JSON decoding to an array
    /// of payment types. You can use this method with data obtained
    /// from the heidelpay backend from your server (e.g. a list of
    /// payment types associated with a customer).
    /// - Parameter jsonArray: array of a dictionary with payment type data
    /// - Returns: array of payment type data that could be decoded. Any
    ///            elements that could not be decoded are filtered automatically.
    public static func map(jsonArray: [[String: Any]]) -> [PaymentType] {
        
        return jsonArray.compactMap({ map(jsonDictionary: $0) })
        
    }

    /// map a dictionary with payment type data to a PaymentType element
    /// - Parameter jsonDictionary: dictionary with payment type data
    /// - Returns: PaymentType element if decoding was successfull. Otherwise nil.
    public static func map(jsonDictionary: [String: Any]) -> PaymentType? {
        guard let methodString = jsonDictionary["method"] as? String,
            let method = PaymentMethod(rawValue: methodString) else {
                
                return nil
        }
        
        guard let paymentId = jsonDictionary["id"] as? String else {
            return nil
        }
                
        var title: String = method.rawValue
        
        switch method {
        case .card:
            if let brand = jsonDictionary["brand"] as? String {
                title = "\(brand)"
            }
        case .sepaDirectDebit, .sepaDirectDebitGuaranteed:
            if let iban = jsonDictionary["iban"] as? String {
                title = iban
            }
        default:
            break
        }
        
        let dataDictionary = jsonDictionary.filter { (key, _) -> Bool in
            return key != "id" && key != "method"
        }
        
        return PaymentType(paymentId: paymentId, paymentMethod: method, title: title, data: dataDictionary)
    }
}

extension PaymentType: Equatable {
    public static func == (lhs: PaymentType, rhs: PaymentType) -> Bool {
        return lhs.paymentId == rhs.paymentId
    }
}
