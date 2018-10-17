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

/// enumeration of possible validation results
public enum PaymentTypeInformationValidationResult {
    /// the checksum was verified
    case validChecksum
    
    /// the provided payment information had an invalid length
    case invalidLength
    
    /// the checksum calculated did not math the checksum provided in the
    /// payment information
    case invalidChecksum
    
    /// the payment information has invalid characters and a checksum
    /// can't be calculated
    case invalidCharacters
}

/// implements various algorithms for calculating and verifying payment information / checksums
class PaymentTypeInformationValidator {
    static let shared = PaymentTypeInformationValidator()
    
    private static let heidelpayIbanCharactersToConvert = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    private init() {        
    }
    
    /// Validates an IBAN by calculating the checksum as described
    /// at https://www.sparkonto.org/manuelles-berechnen-der-iban-pruefziffer-sepa/
    /// - Parameter iban: IBAN to validate
    /// - Returns: result of the validation
    func validate(iban: String) -> PaymentTypeInformationValidationResult {
        if iban.count < 9 {
            return .invalidLength
        }
        
        let normalizedIban = normalize(iban: iban)
        
        if normalizedIban.heidelpayStrictlyNumerical == false {
            return .invalidCharacters
        }
        
        var modulo: Int!
        var calculationString: String? = normalizedIban
        
        while calculationString != nil {
        
            let result = nextModuloPart(forIBAN: calculationString!, modulo: modulo)  
            modulo = result.modulo
            calculationString = result.remainingString
            
        }
        return modulo == 1 ? .validChecksum : .invalidChecksum
    }
    
    /// Validates a Credit Card Number with the Luhn algorithm as described
    /// at https://en.wikipedia.org/wiki/Luhn_algorithm
    /// - Parameter cardNumber: Credit card number ot validate
    /// - Returns: result of the validation
    func validate(cardNumber: String) -> PaymentTypeInformationValidationResult {
        let condensedCardNumber = cardNumber.heidelpay_condensedString()
        var index = condensedCardNumber.count - 2
        var doublingDigit = true
        var sum = 0
        while index >= 0 {
            let characterIndex = condensedCardNumber.index(condensedCardNumber.startIndex, offsetBy: index)
            let character = condensedCardNumber[characterIndex]
            if let intValueForCharacter = Int(String(character)) {
                var addedValue = intValueForCharacter * (doublingDigit ? 2 : 1)
                if addedValue > 9 {
                    addedValue -= 9
                }
                sum += addedValue
            } else {
                return .invalidCharacters
            }
            
            index -= 1
            doublingDigit = !doublingDigit
        }
        
        let checkDigitIndex = condensedCardNumber.index(condensedCardNumber.startIndex,
                                                        offsetBy: condensedCardNumber.count - 1)
        if let checkDigitValue = Int(String(condensedCardNumber[checkDigitIndex])) {
            if (sum + checkDigitValue) % 10 == 0 {
                return .validChecksum
            } else {
                return .invalidChecksum
            }
        }
        
        return .invalidCharacters
    }

    private func normalize(iban: String) -> String {
        let cleanedIBAN = iban.uppercased().heidelpay_condensedString()
            
        let reversedIBAN = reverse(iban: cleanedIBAN)
        
        return convertAlphaCharactersToDigits(iban: reversedIBAN)
    }
    
    private func reverse(iban: String) -> String {
        let endIndex = iban.index(iban.startIndex, offsetBy: 4)
        let startCharacters = iban[..<endIndex]
        let remainder = iban[endIndex...]
        return "\(remainder)\(startCharacters)"
    }
    
    private func convertAlphaCharactersToDigits(iban: String) -> String {
        let charsToConvert = PaymentTypeInformationValidator.heidelpayIbanCharactersToConvert
        
        var convertedString = iban
        for index in 0 ..< charsToConvert.count {
            
            let indexForCharacter = charsToConvert.index(charsToConvert.startIndex, offsetBy: index)
            let character = String(charsToConvert[indexForCharacter])
            
            convertedString = convertedString.replacingOccurrences(of: character, with: "\(index + 10)")
        }
        return convertedString
    }

    private func nextModuloPart(forIBAN iban: String, modulo: Int?) -> (modulo: Int, remainingString: String?) {
        if let modulo = modulo {
            if iban.count < 7 {
                return (Int("\(modulo)\(iban)")! % 97, nil)
            } else {
                let calculationRange = iban.index(iban.startIndex, offsetBy: 7)
                let calculationString = String(iban[..<calculationRange])
                let newModulo = Int("\(modulo)\(calculationString)")! % 97
                let remainder = String(iban[calculationRange...])
                return (newModulo, remainder.count > 0 ? remainder : nil)
            }
        }
        let firstModuloRangeEndIndex = iban.index(iban.startIndex, offsetBy: 9)
        let firstModulo = Int(String(iban[..<firstModuloRangeEndIndex]))! % 97
        return (firstModulo, String(iban[firstModuloRangeEndIndex...]))
    }

}
