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

/// Holds information about the user input for a card number
public struct CardNumberInput {
    
    /// the determined CardType for the input
    internal(set) public var type: CardType
    
    /// normalized card number (without whitespaces and grouping) to be passed to API endpoints
    internal(set) public var normalizedCardNumber: String
    
    /// properly formatted card number (with grouping appropriate for the type) to be displayed to the user
    internal(set) public var formattedCardNumber: String?
    
    /// Validation result for the given card number. Includes length validation and Luhn check
    internal(set) public var validationResult: PaymentTypeInformationValidationResult
    
    /// true when the validationResult is equal to validChecksum
    public var valid: Bool {
        return validationResult == .validChecksum
    }

}

/// Holds information about the user input for a card expiry (month & year)
public struct CardExpiryInput {
    
    /// the normalized expiryDate (MM/YY) if the input is valid or the current user input otherwise
    internal(set) public var expiryDate: String
    
    /// flag to determine if the expiryDate is valid.
    /// Includes format checks as well as if the expiryDate lies in the future
    internal(set) public var valid: Bool
    
    // the month of the expiry date as an Int between 1-12 or -1 if the expiryDate is not valid
    public var month: Int {
        if expiryDate.count == 5 {
            let monthValue = Int(String(expiryDate[..<expiryDate.index(expiryDate.startIndex, offsetBy: 2)]))!
            if monthValue > 0 && monthValue < 13 {
                return monthValue
            }
        }
        return -1
    }
    
    // the year of the expiry date as an Int with the full year count (e.g. 2025 if the expiry date is XX/25)
    /// or -1 if the expiryDate is not valid
    public var year: Int {
        if expiryDate.count == 5 {
            return Int(String(expiryDate[expiryDate.index(expiryDate.endIndex, offsetBy: -2)...]))! + 2000
        }
        return -1
    }
}

/// Holds information about the user input for the card CVV
public struct CardCvvInput {
    /// the entered cvv
    internal(set) public var cvv: String
    
    /// flag to determine if the cvv is valid (only performs length check)
    internal(set) public var valid: Bool
}

/// Holds information about the user input for an IBAN
public struct IbanInput {
    /// the entered iban
    internal(set) public var iban: String
    
    /// Validation result for the given IBAN. Includes length validation and IBAN checksum calculation
    internal(set) public var validationResult: PaymentTypeInformationValidationResult
    
    /// true when the validationResult is equal to validChecksum
    public var valid: Bool {
        return validationResult == .validChecksum
    }
}
