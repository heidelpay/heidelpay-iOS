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

/// protocol implemented by all input fields provided
/// by the SDK (e.g. credit card input)
public protocol HeidelpayInputField {
    
    /// delegate for callbacks on value changes
    var inputFieldDelegate: HeidelpayInputFieldDelegate? { get set }
    
    /// is the current input of the field valid?
    var isValid: Bool { get }
    
    /// current value of the input field or nil if there is no value
    var value: HeidelpayInput? { get }
    
}

/// delegate for HeidelpayInputField
public protocol HeidelpayInputFieldDelegate: class {
    
    /// called whenever the value of the field has changed
    /// - Parameter inputField: field that has changed
    func inputFieldDidChange(_ inputField: HeidelpayInputField)
}
