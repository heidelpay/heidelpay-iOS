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

/// Extension for UIImage providing helpful methods
extension UIImage {

    /// Proportionally resize the image to fit in the given size
    /// - Parameter targetSize: the target size the image should have.
    ///             If the image does not match the proportions of the targetSize,
    ///             one axis might be smaller than the targetSize axis
    /// - Returns: a resized UIImage
    func heidelpay_resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
        
    /// Load an image resource from the included SDK resource bundle
    /// - Parameter named: The name of the image resourcs (without the file extension)
    /// - Returns: the loaded image resource or nil if the bundle or resource could not be loaded
    class func heidelpay_resourceImage(named: String) -> UIImage? {
        if let frameworkResourcePath = Bundle(for: Heidelpay.self).resourcePath {
            let bundlePath = (frameworkResourcePath as NSString).appendingPathComponent("HeidelpaySDKResources.bundle")
            if let bundle = Bundle(path: bundlePath) {
                return UIImage(named: named, in: bundle, compatibleWith: nil)
            }
        }
        return nil
    }
}
