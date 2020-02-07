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

/// heidelpay backend request for retrieving Hire Purchase Plans
struct RetrieveHirePurchasePlansRequest: HeidelpayRequest {
    let requestPath: String
    
    init(amount: Float, currencyCode: String, effectiveInterest: Float, orderDate: Date?=nil) {
        var path = "types/hire-purchase-direct-debit/plans?amount=\(amount)&currency=\(currencyCode)"
        path.append("&effectiveInterest=\(effectiveInterest)")
        if let orderDate = orderDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            path.append("&orderDate=\(formatter.string(from: orderDate))")
        }
        requestPath = path
    }
    
    func createResponse(fromData data: Data) throws -> Any {
        return try JSONDecoder().decode(RetrieveHirePurchasePlansResponse.self, from: data)
    }
    
}

/// heidelpay backend response for Hire Purchase Plans
struct RetrieveHirePurchasePlansResponse: Decodable {
    let code: String
    let entity: [HirePurchasePlan]?
}
