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

enum GroupingStyle: Equatable {
    
    case fixedGroupsAndVariableLength(groupSize: Int, maximumLength: Int)
    case variableGroups(groupSizes: [Int], maximumLength: Int)
    
    func groupedString(_ string: String, separator: String) -> String {
        let string = String.heidelpay_nonOptionalCondensedString(string, groupingSeparator: separator)
            .heidelpay_condensedString()
        switch self {
        case .fixedGroupsAndVariableLength(groupSize: let groupSize, maximumLength: let maximumLength):
            var groupedString = ""
            
            for index in 0..<string.count {
                let condensedOriginalString = String.heidelpay_nonOptionalCondensedString(groupedString,
                                                                                          groupingSeparator: separator)
                if condensedOriginalString.count < maximumLength {
                    let character = String(string[string.index(string.startIndex, offsetBy: index)])
                    groupedString = "\(groupedString)\(character)"
                    
                    let components = groupedString.components(separatedBy: separator)
                    let lastComponent = components.last!
                    
                    let condensedModifiedString = String.heidelpay_nonOptionalCondensedString(groupedString,
                                                                                      groupingSeparator: separator)
                    
                    if lastComponent.count == groupSize && condensedModifiedString.count < maximumLength {
                        groupedString = "\(groupedString)\(separator)"
                    }
                }
            }
            
            return groupedString
        case .variableGroups(groupSizes: let groupSizes, maximumLength: let maximumLength):
            var groupedString = ""
            
            for index in 0..<string.count {
                let condensedOriginalString = String.heidelpay_nonOptionalCondensedString(groupedString,
                                                                                          groupingSeparator: separator)
                if condensedOriginalString.count < maximumLength {
                    let character = String(string[string.index(string.startIndex, offsetBy: index)])
                    groupedString = "\(groupedString)\(character)"
                    
                    let components = groupedString.components(separatedBy: separator)
                    let lastComponent = components.last!
                    let componentSize = groupSizes[components.count - 1]
                    let condensedModifiedString = String
                        .heidelpay_nonOptionalCondensedString(groupedString,
                                                              groupingSeparator: separator)
                    if lastComponent.count == componentSize && condensedModifiedString.count < maximumLength {
                        groupedString = "\(groupedString)\(separator)"
                    }
                }
            }
            
            return groupedString
        }
    }
    
    static func == (lhs: GroupingStyle, rhs: GroupingStyle) -> Bool {
        switch (lhs, rhs) {
        
        case let (.fixedGroupsAndVariableLength(groupSize1, maximumLength1),
                  .fixedGroupsAndVariableLength(groupSize2, maximumLength2)):
            return groupSize1 == groupSize2 && maximumLength1 == maximumLength2
            
        case let (.variableGroups(groupSizes1, maximumLength1),
                  .variableGroups(groupSizes2, maximumLength2)):
            return groupSizes1 == groupSizes2 && maximumLength1 == maximumLength2
            
        default: return false
            
        }
    }
    
}
