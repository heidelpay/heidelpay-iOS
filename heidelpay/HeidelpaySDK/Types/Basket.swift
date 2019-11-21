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

/// Basket structure to store a basket on the Heidelpay backend
public struct Basket: Encodable {

    /// Total amount of the whole basket in the specified currency.
    /// It should equal the sum of all basketItems.amountGross.
    public let amountTotalGross: Float?
    
    /// Total discount amount of the whole basket in the specified currency,
    /// which will be subtracted from the amountTotal.
    public let amountTotalDiscount: Float?

    /// Total Vat amount of the basket in the unit of the currency, which is already included in amountTotal.
    /// It should equal the sum of all basketItems.amountVat.
    public let amountTotalVat: Float?

    /// Currency code in ISO_4217 format (max. 3)
    public let currencyCode: String?

    /// A basket or shop reference ID sent from the shop's backend (mandatory & unique)
    public let orderId: String

    /// A basket note (max 3900)
    public let note: String?
    
    /// Basket items
    public let basketItems: [BasketItem]
    
    public init(orderId: String, items: [BasketItem], amountTotalGross: Float?=nil,
                amountTotalDiscount: Float?=nil, amountTotalVat: Float?=nil,
                currencyCode: String?=nil, note: String?=nil) {
        
        self.orderId = orderId
        self.basketItems = items
        self.amountTotalGross = amountTotalGross
        self.amountTotalDiscount = amountTotalDiscount
        self.amountTotalVat = amountTotalVat
        self.currencyCode = currencyCode
        self.note = note
    }

}

public struct BasketItem: Encodable {
    
    /// Unique basket item reference ID (within the basket) (max. 255)
    public let basketItemReferenceId: String
    
    /// Unit description of the item e.g. "pc" (max. 255)
    public let unit: String?
    
    /// Quantity of the basket item
    public let quantity: Int
    
    /// Discount amount for the basket item (multiplied by the basketItems.quantity)
    public let amountDiscount: Float?
    
    /// Vat value for the basket item in percent (0-100)
    public let vat: Int?
    
    /// Gross amount (= amountNet + amountVat) in the specified currency. Equals amountNet if vat value is 0
    public let amountGross: Float?
    
    /// Vat amount. Equals 0 if vat value is 0. Should equal the basketItems.vat multiplied by
    /// basketItems.amountNet for each basket item.
    public let amountVat: Float?
    
    /// Net amount per unit
    public let amountPerUnit: Float
    
    /// Net amount. Equals amountGross if vat value is 0.
    public let amountNet: Float?
    
    /// Title of the basket item (max. 255)
    public let title: String
    
    /// The defined subTitle which is displayed on our Payment Page later on
    public let subTitle: String?
    
    /// The defined imageUrl for the related basketItem and will be displayed on our Payment Page
    public let imageUrl: String?
    
    /// Type of the basket item, e. g. "goods", "shipment", "voucher", "digital" or "physical"
    public let type: String?
        
    public init(referenceId: String, title: String, quantity: Int, amountPerUnit: Float, unit: String?=nil,
                amountDiscount: Float?=nil, vat: Int?=nil, amountGross: Float?=nil, amountVat: Float?=nil,
                amountNet: Float?=nil, subTitle: String?=nil, imageUrl: String?=nil, type: String?=nil) {
        
        self.basketItemReferenceId = referenceId
        self.title = title
        self.quantity = quantity
        self.amountPerUnit = amountPerUnit
        self.unit = unit
        self.amountDiscount = amountDiscount
        self.vat = vat
        self.amountGross = amountGross
        self.amountVat = amountVat
        self.amountNet = amountNet
        self.subTitle = subTitle
        self.imageUrl = imageUrl
        self.type = type
        
    }
}
