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


import UIKit

/// UITextFieldDelegate that forwards all delegate callbacks to a chained delegate
class ChainingTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    /// the delegate that callbacks are forwarded to
    weak var chainedDelegate: UITextFieldDelegate?
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        if chainedDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) == false {
            return false
        }
        
        return true
    }
    
    // MARK: UITextFieldDelegate call fowarding
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let value = chainedDelegate?.textFieldShouldBeginEditing?(textField) {
            return value
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        chainedDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let value = chainedDelegate?.textFieldShouldEndEditing?(textField) {
            return value
        }
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        chainedDelegate?.textFieldDidEndEditing?(textField)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        chainedDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let value = chainedDelegate?.textFieldShouldClear?(textField) {
            return value
        }
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let value = chainedDelegate?.textFieldShouldReturn?(textField) {
            return value
        }
        return false
    }
    
}
