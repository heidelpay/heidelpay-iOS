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

// Importing heidelpay as normal framework. Only public and open elements are visible
import HeidelpaySDK

class FTCreateCustomerTest: FTBaseTest {
    
    func testCreateMinimalCustomer() {
        
        let heidelPay = setupHeidelpay()
        
        let customer = Customer.createCustomer(firstname: "John", lastname: "Doe")
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createCustomer(customer, completion: { customerId, error in
            XCTAssertNotNil(customerId)
            XCTAssertNil(error)
            
            expCreate.fulfill()
        })
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreateCustomerWithAllDetails() {
        
        let heidelPay = setupHeidelpay()
        
        let billingAddress = CustomerAddress(name: "John Doe", street: "Doe Street 1",
                                             state: "VI", zip: "1010", city: "Vienna", country: "AT")
        let shippingAddress = CustomerAddress(name: "John Doe Home", street: "John Street 2",
                                              state: "VI", zip: "1190", city: "Vienna", country: "AT")
        let uniqueCustomerId = "test-\(Date.timeIntervalSinceReferenceDate)"
        let customer = Customer.createCustomer(firstname: "John", lastname: "Doe", customerId: uniqueCustomerId,
                                salutation: "mr", company: "Doe's", birthDate: "01.01.1970",
                                email: "john.doe@does.com", phone: "012345", mobile: "123456",
                                billingAddress: billingAddress, shippingAddress: shippingAddress)
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createCustomer(customer, completion: { customerId, error in
            XCTAssertNotNil(customerId)
            XCTAssertNil(error)
            
            expCreate.fulfill()
        })
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testCreateRegisteredCompanyCustomer() {
        
        let heidelPay = setupHeidelpay()
        
        let billingAddress = CustomerAddress(name: "John Doe", street: "Doe Street 1",
                                             state: "VI", zip: "1010", city: "Vienna", country: "AT")
        let customer = Customer.createRegisteredCompanyCustomer(company: "Sample Company",
                                                                commercialRegisterNumber: "FN 123456",
                                                                billingAddress: billingAddress)
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createCustomer(customer, completion: { customerId, error in
            XCTAssertNotNil(customerId)
            XCTAssertNil(error)
            
            expCreate.fulfill()
        })
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }
    
    func testCreateNonRegisteredCompanyCustomer() {
        
        let heidelPay = setupHeidelpay()
        
        let billingAddress = CustomerAddress(name: "John Doe", street: "Doe Street 1",
                                             state: "VI", zip: "1010", city: "Vienna", country: "AT")
        let customer = Customer.createNonRegisteredCompanyCustomer(firstname: "John", lastname: "Doe",
                                                                   company: "Doe Company",
                                                                   birthDate: "01.01.1970",
                                                                   email: "john@doe.company.com",
                                                                   billingAddress: billingAddress,
                                                                   function: "OWNER",
                                                                   commercialSector: "AIRPORT")
        
        let expCreate = expectation(description: "create")
        
        heidelPay.createCustomer(customer, completion: { customerId, error in
            XCTAssertNotNil(customerId)
            XCTAssertNil(error)
            
            expCreate.fulfill()
        })
        
        waitForExpectations(timeout: 10.0, handler: nil)
        
    }

}
