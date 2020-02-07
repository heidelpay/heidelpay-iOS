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

import UIKit

/// Extension on String to provide helper methods
extension String {
    
    /// Returns true if the string only contains numbers and no other characters (including whitespaces)
    var heidelpayStrictlyNumerical: Bool {
        for index in 0..<self.count {
            if Int(String(self[self.index(self.startIndex, offsetBy: index)])) == nil {
                return false
            }
        }
        return true
    }
    
    /// Returns a new String that removes all whitespaces and newlines from the string
    /// (even the ones contained within the string)
    func heidelpay_condensedString() -> String {
        let components = self.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: "")
    }
    
    /// Returns a new String that trims whitespaces and newlines and removes the
    /// passed groupingSeparater or nil if the resulting string is empty or the passed value is nil or not a String
    /// - Parameter value: the value to validate
    /// - Parameter groupingSeparater: the separator that is removed from the given value
    /// - Returns: a trimmed String without the groupingSeparator or nil if the passed value is nil,
    ///              not a String or the resulting string is empty
    static func heidelpay_nonEmptyCondensedString(_ value: String?, groupingSeparator: String = " ") -> String? {
        if let stringValue = value {
            if stringValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty == false {
                return stringValue.replacingOccurrences(of: groupingSeparator, with: "")
            }
        }
        return nil
    }
    
    /// Returns a new String that trims whitespaces and newlines and removes the
    /// passed groupingSeparater or an empty string if the resulting string is empty,
    /// the passed value is nil or not a String
    /// - Parameter value: the value to validate
    /// - Parameter groupingSeparater: the separator that is removed from the given value
    /// - Returns: a trimmed String without the groupingSeparator or
    /// an empty string if the passed value is nil or not a String
    static func heidelpay_nonOptionalCondensedString(_ value: String?, groupingSeparator: String = " ")
        -> String {
        if let stringValue = value {
            if stringValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).isEmpty == false {
                return stringValue.replacingOccurrences(of: groupingSeparator, with: "")
            }
        }
        return ""
    }
    
    /// Removes a new String that trims all whitespaces and newlines from the whole given string
    /// or nil if the resulting string is empty, the passed value is nil or not a String
    /// Parameter value: the value to validate
    /// Returns: a trimmed String without whitespaces and newlines or nil if the passed value is nil,
    ///         not a String or the resulting string is empty
    static func heidelpay_asNonEmptyStringWithoutWhitespaces(_ value: String?) -> String? {
        if let stringValue = value {
            let condensedValue = stringValue.heidelpay_condensedString()
            if condensedValue.isEmpty == false {
                return condensedValue
            }
        }
        return nil
    }
    
    /// Returns the passed value or an empty string if the value is nil
    /// Parameter value: the value to validate
    /// Returns: the value cast to String or an empty String if the value is nil
    static func heidelpay_nonOptionalString(_ value: String?) -> String {
        if let stringValue = value {
            return stringValue
        }
        return ""
    }
}
