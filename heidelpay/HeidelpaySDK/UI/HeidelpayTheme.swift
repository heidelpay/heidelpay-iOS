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

/// Defines colors and fonts for the UI Components of the heidelpay SDK
/// You can adjust the look and feel through the various properties of this
/// instance through the sharedInstance static property
public class HeidelpayTheme {
    /// shared instance used by UI components
    public static let sharedInstance: HeidelpayTheme = {
        return HeidelpayTheme()
    }()
    
    /// private initializer - use shared instance
    private init() {
        let placeholderColor = UIColor(red: 209.0/255.0,
                                       green: 209.0/255.0,
                                       blue: 214.0/255.0,
                                       alpha: 1)
        self.placeholderColor = placeholderColor
    }
    
    /// font used by UI Components (e.g. UITextField.font)
    public var font = UIFont.systemFont(ofSize: 17, weight: .regular)

    /// text color of UI Components
    public var textColor = UIColor.black
    
    /// placeholder color of UI Components
    public var placeholderColor: UIColor
        
    /// color used for signaling error (border color)
    public var errorColor = UIColor(red: 208.0/255.0, green: 2.0/255.0, blue: 27.0/255.0, alpha: 1)
}
