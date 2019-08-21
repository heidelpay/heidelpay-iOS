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

/// Defines colors and fonts for the UI Components of the HeidelPay SDK
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
        self.creditCardIconTintColor = placeholderColor
        
        registerHeidelPayIconFont()
    }
    
    /// load the HeidelPay font with icons for credit card types from the framework bundle
    private func registerHeidelPayIconFont() {
        guard let frameworkResourcePath = Bundle(for: Heidelpay.self).resourcePath else {
            // no framework resources found
            return
        }
        
        let bundlePath = (frameworkResourcePath as NSString).appendingPathComponent("HeidelpaySDKResources.bundle")
        let fontPath = (bundlePath as NSString).appendingPathComponent("heidelpay.ttf")

        guard FileManager.default.fileExists(atPath: fontPath) else {
            // font not found in resources
            return
        }

        let heidelPayFontUrl = URL(fileURLWithPath: fontPath)
        CTFontManagerRegisterFontsForURL(heidelPayFontUrl as CFURL, CTFontManagerScope.none, nil)
    }
    
    /// font used by UI Components (e.g. UITextField.font)
    public var font = UIFont.systemFont(ofSize: 17, weight: .regular)

    /// text color of UI Components
    public var textColor = UIColor.black
    
    /// placeholder color of UI Components
    public var placeholderColor: UIColor
    
    /// tint color for credt card icon
    public var creditCardIconTintColor: UIColor
    
    /// color used for signaling error (border color)
    public var errorColor = UIColor(red: 1, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1)
}
