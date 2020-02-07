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

// swiftlint:disable function_parameter_count

/// Customer data to be used in authorize or charges calls.
/// The customer component is an additional input form for certain payment methods.
public struct Customer: Encodable {
    
    /// First name (max: 40 chars)
    public let firstname: String?
    
    /// Last name (max: 40 chars)
    public let lastname: String?
    
    /// Must be unique and identifies the customer. Can be used in place of the resource id (max: 256 chars)
    public let customerId: String?
    
    /// Must be either 'mr', 'mrs' or 'unknown'
    public let salutation: String?
    
    /// Company name (max: 40 chars)
    public let company: String?
    
    /// Birthdate of the customer in format yyyy-mm-dd or dd.mm.yyyy
    public let birthDate: String?
    
    /// E-Mail of customer (max: 100 chars)
    public let email: String?
    
    /// Phone number of the customer (max: 20 chars)
    public let phone: String?
    
    /// Mobile phone (max: 40 chars)
    public let mobile: String?
    
    /// Billing address of the customer
    public let billingAddress: CustomerAddress?
    
    /// Shipping address of the customer
    public let shippingAddress: CustomerAddress?
    
    /// Company Info
    let companyInfo: CompanyInfo?
    
    /// Create a customer structure for a natural / private customer
    /// - Parameter firstname: First name (max: 40 chars)
    /// - Parameter lastname: Last name (max: 40 chars)
    /// - Parameter customerId: Unique identifier of the customer
    /// - Parameter salutation Must be either 'mr', 'mrs' or 'unknown'
    /// - Parameter company: The name of the company
    /// - Parameter birthDate: Birthdate of the customer in format yyyy-mm-dd or dd.mm.yyyy
    /// - Parameter email: email of the customer
    /// - Parameter phone: phone number of customer
    /// - Parameter mobile: mobile phone number of customer
    /// - Parameter billingAddress: Billing address of the customer
    /// - Parameter shippingAddress: shipping address of customer
    public static func createCustomer(firstname: String, lastname: String, customerId: String?=nil,
                                      salutation: String?=nil, company: String?=nil, birthDate: String?=nil,
                                      email: String?=nil, phone: String?=nil,
                                      mobile: String?=nil, billingAddress: CustomerAddress?=nil,
                                      shippingAddress: CustomerAddress?=nil) -> Customer {
    
        return Customer(firstname: firstname, lastname: lastname, customerId: customerId, salutation: salutation,
                        company: company, birthDate: birthDate, email: email, phone: phone, mobile: mobile,
                        billingAddress: billingAddress, shippingAddress: shippingAddress, companyInfo: nil)
    }
    
    /// Create a customer structure for a registered company
    /// - Parameter company: The name of the company
    /// - Parameter commercialRegisterNumber: The identity of the company to verify the legal existence
    /// - Parameter billingAddress: Billing address of the company
    /// - Parameter customerId: Unique identifier of the customer
    /// - Parameter email: email of the company
    /// - Parameter phone: phone number of company
    /// - Parameter mobile: mobile phone number of company
    /// - Parameter shippingAddress: shipping address of company
    public static func createRegisteredCompanyCustomer(company: String, commercialRegisterNumber: String,
                                                       billingAddress: CustomerAddress, customerId: String?=nil,
                                                       email: String?=nil, phone: String?=nil,
                                                       mobile: String?=nil,
                                                       shippingAddress: CustomerAddress?=nil) -> Customer {
    
        return Customer(firstname: nil, lastname: nil, customerId: customerId, salutation: nil,
                        company: company, birthDate: nil, email: email, phone: phone, mobile: mobile,
                        billingAddress: billingAddress, shippingAddress: shippingAddress,
                        companyInfo: CompanyInfo.registered(commercialRegisterNumber: commercialRegisterNumber))
    }
    
    /// Create a customer structure for a non registered company
    /// - Parameter firstname: First name (max: 40 chars)
    /// - Parameter lastname: Last name (max: 40 chars)
    /// - Parameter company: The name of the company
    /// - Parameter birthDate: Birthdate of the customer in format yyyy-mm-dd or dd.mm.yyyy
    /// - Parameter email: email of the customer
    /// - Parameter billingAddress: Billing address of the customer
    /// - Parameter function: Customer's working function
    /// - Parameter commercialSector: Customer's  working commercial sector
    /// - Parameter customerId: Unique identifier of the customer
    /// - Parameter salutation Must be either 'mr', 'mrs' or 'unknown'
    /// - Parameter phone: phone number of customer
    /// - Parameter mobile: mobile phone number of customer
    /// - Parameter shippingAddress: shipping address of customer
    public static func createNonRegisteredCompanyCustomer(firstname: String, lastname: String, company: String,
                                                          birthDate: String, email: String,
                                                          billingAddress: CustomerAddress,
                                                          function: String, commercialSector: String,
                                                          customerId: String?=nil,
                                                          salutation: String?=nil, phone: String?=nil,
                                                          mobile: String?=nil,
                                                          shippingAddress: CustomerAddress?=nil) -> Customer {
    
        return Customer(firstname: firstname, lastname: lastname, customerId: customerId, salutation: salutation,
                        company: company, birthDate: birthDate, email: email, phone: phone, mobile: mobile,
                        billingAddress: billingAddress, shippingAddress: shippingAddress,
                        companyInfo: CompanyInfo.nonRegistered(function: function, commercialSector: commercialSector))
    }
    
}

/// Address structure of a customer
public struct CustomerAddress: Encodable {
    
    /// Billing address first and last name (max. 40 chars)
    public let name: String
    
    /// Billing address street (max. 50 chars)
    public let street: String
    
    /// Billing address state in ISO 3166-2 format (max. 8 chars)
    public let state: String
    
    /// Billing address zip code (max. 10 chars)
    public let zip: String
    
    /// Billing address city (max. 30 chars)
    public let city: String
    
    /// Billing address country in ISO A2 format (max. 2 chars)
    public let country: String
    
    public init(name: String, street: String, state: String, zip: String, city: String, country: String) {
        self.name = name
        self.street = street
        self.state = state
        self.zip = zip
        self.city = city
        self.country = country
    }
        
}

/// Company Info of a registered Company
struct CompanyInfo: Encodable {

    /// The fix value: registered
    let registrationType: String

    /// The identify your company or limited partnership and verify its legal existence as an incorporated entity
    let commercialRegisterNumber: String?
    
    /// The identify your working function
    let function: String?
    
    /// The identify your working commercial sector
    let commercialSector: String?
    
    static func registered(commercialRegisterNumber: String) -> CompanyInfo {
    
        return CompanyInfo(registrationType: "registered",
                           commercialRegisterNumber: commercialRegisterNumber,
                           function: nil,
                           commercialSector: nil)
        
    }
    
    static func nonRegistered(function: String, commercialSector: String) -> CompanyInfo {

        return CompanyInfo(registrationType: "not_registered",
                           commercialRegisterNumber: nil,
                           function: function,
                           commercialSector: commercialSector)

    }
}
