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

public enum CardType {
    case unknown
    case visa
    case americanExpress
    case masterCard
    case maestro
    
    init(cardNumber: String) {
        if let firstCharacter = cardNumber.first {
            switch firstCharacter {
                
            case "2", "5":
                self = .masterCard
                
            case "3":
                self = .americanExpress
                
            case "4":
                self = .visa
                
            case "6", "7", "9":
                self = .maestro
                
            default:
                self = .unknown
            }
        } else {
            self = .unknown
        }
    }
    
    var minimumLength: Int {
        switch self {
            
        case .americanExpress:
            return 15
            
        case .visa:
            return 16
            
        case .maestro:
            return 12
            
        default: return 16
            
        }
    }
    
    var maximumLength: Int {
        switch self {
            
        case .americanExpress:
            return 15
            
        case .maestro:
            return 19
            
        default: return 16
            
        }
    }
    
    public func cardIconWithTargetSize(_ targetSize: CGSize) -> UIImage? {
        switch self {
            
        case .masterCard:
            return UIImage.heidelpay_resourceImage(named: "payment_method-mastercard")?
                .heidelpay_resize(targetSize: targetSize)
        case .americanExpress:
            return UIImage.heidelpay_resourceImage(named: "payment_method-american-express")?
                .heidelpay_resize(targetSize: targetSize)
        case .visa:
            return UIImage.heidelpay_resourceImage(named: "payment_method-visa")?
                .heidelpay_resize(targetSize: targetSize)
        case .maestro:
            return UIImage.heidelpay_resourceImage(named: "payment_method-maestro")?
                .heidelpay_resize(targetSize: targetSize)
        default:
            return PaymentMethod.card.icon?.heidelpay_resize(targetSize: targetSize)
            
        }
    }
    
    func validate(cardNumber: String) -> PaymentTypeInformationValidationResult {
        let condensedNumber = cardNumber.heidelpay_condensedString()
        
        guard condensedNumber.count >= minimumLength && condensedNumber.count <= maximumLength else {
            return .invalidLength
        }
        
        return PaymentTypeInformationValidator.shared.validate(cardNumber: cardNumber)
    }
    
    var groupingMode: GroupingStyle {
        switch self {
        
        case .americanExpress:
            return .variableGroups(groupSizes: [4, 6, 5], maximumLength: maximumLength)
        
        default:
            return .fixedGroupsAndVariableLength(groupSize: 4, maximumLength: maximumLength)
            
        }
    }
}
