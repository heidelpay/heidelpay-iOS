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
@testable import HeidelpaySDK

class GroupingStyleTest: XCTestCase {
    
    func testStyleEquality() {
        XCTAssertEqual(GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 15),
                       GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 15))
        XCTAssertNotEqual(GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 15),
                          GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 12))
        XCTAssertNotEqual(GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 15),
                          GroupingStyle.fixedGroupsAndVariableLength(groupSize: 43, maximumLength: 15))
        
        XCTAssertNotEqual(GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 15),
                          GroupingStyle.variableGroups(groupSizes: [1, 2, 3], maximumLength: 4))
        
        XCTAssertEqual(GroupingStyle.variableGroups(groupSizes: [3, 5, 5, 2], maximumLength: 15),
                       GroupingStyle.variableGroups(groupSizes: [3, 5, 5, 2], maximumLength: 15))
        XCTAssertNotEqual(GroupingStyle.variableGroups(groupSizes: [3, 5, 5, 2], maximumLength: 15),
                          GroupingStyle.variableGroups(groupSizes: [3, 5, 5, 2], maximumLength: 12))
        
        XCTAssertNotEqual(GroupingStyle.variableGroups(groupSizes: [3, 5, 5, 2], maximumLength: 15),
                          GroupingStyle.variableGroups(groupSizes: [2, 5, 3, 5], maximumLength: 15))
        XCTAssertNotEqual(GroupingStyle.variableGroups(groupSizes: [3, 5, 5, 2], maximumLength: 15),
                          GroupingStyle.fixedGroupsAndVariableLength(groupSize: 4, maximumLength: 2))
    }
    
    func testFixedGroupStyle() {
        let groupingMode = GroupingStyle.fixedGroupsAndVariableLength(groupSize: 2, maximumLength: 17)
        XCTAssertEqual(groupingMode.groupedString("12  31  2  3 123 1\n23123 1  2\n2222", separator: "  "),
                       "12  31  23  12  31  23  12  31  2")
        
        XCTAssertEqual(groupingMode.groupedString("12  31  2  3 123 1\n23123 1 2 99999999", separator: "  "),
                       "12  31  23  12  31  23  12  31  2")
    }
    
    func testVariableGroupStyle() {
        let groupingMode = GroupingStyle.variableGroups(groupSizes: [3, 2, 8, 4], maximumLength: 17)
        
        XCTAssertEqual(groupingMode.groupedString("111\n\n2    2    88888888\n4444", separator: " "),
                       "111 22 88888888 4444")
        XCTAssertEqual(groupingMode.groupedString("111\n\n2    2    88888888\n4444  99999", separator: " "),
                       "111 22 88888888 4444")
        
        XCTAssertEqual(groupingMode.groupedString("111\n\n2    2    88888888\n44  99999", separator: " "),
                       "111 22 88888888 4499")
        
        XCTAssertEqual(groupingMode.groupedString("111\n\n2    2    88888888\n44   ", separator: " "),
                       "111 22 88888888 44")
    }
}
