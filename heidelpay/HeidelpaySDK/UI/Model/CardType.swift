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
    
    public init(brandName: String) {
        switch brandName {
        case "MASTER":
            self = .masterCard
        case "VISA":
            self = .visa
        default:
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
    
    public var icon: UIImage? {
        switch self {
            
        case .masterCard:
            return UIImage.heidelpay_resourceImage(named: "cc-mastercard")
        case .americanExpress:
            return UIImage.heidelpay_resourceImage(named: "cc-amex")
        case .visa:
            return UIImage.heidelpay_resourceImage(named: "cc-visa")
        case .maestro:
            return UIImage.heidelpay_resourceImage(named: "card-debit")
        default:
            return UIImage.heidelpay_resourceImage(named: "card-debit")            
        }
    }
    
    static var placeholderIcon: UIImage? {
        return UIImage.heidelpay_resourceImage(named: "cc-input-empty")
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
