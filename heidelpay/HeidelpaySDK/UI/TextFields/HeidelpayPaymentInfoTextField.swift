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

// swiftlint:disable weak_delegate

/// base class for heidelpay UI components for entering
/// payment information.
public class HeidelpayPaymentInfoTextField: UITextField, HeidelpayInputField {
    
    public weak var inputFieldDelegate: HeidelpayInputFieldDelegate?
    
    private var strongReferenceToDelegate: UITextFieldDelegate?
    
    private(set) public var value: HeidelpayInput?
    
    public var isValid: Bool {
        return value?.valid ?? false
    }
    
    var theme: HeidelpayTheme = .sharedInstance
    
    func updateValue(newValue: HeidelpayInput?) {
        self.value = newValue
        
        inputFieldDelegate?.inputFieldDidChange(self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        if type(of: self) == HeidelpayPaymentInfoTextField.self {
            fatalError("Base class HeidelpayPaymentInfoTextField shall not be used")
        }
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        if type(of: self) == HeidelpayPaymentInfoTextField.self {
            fatalError("Base class HeidelpayPaymentInfoTextField shall not be used")
        }
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    func commonInit() {
        
    }
    
    func setup(placeHolder: String, textFieldDelegate: UITextFieldDelegate, keyboardType: UIKeyboardType = .numberPad) {
        self.delegate = textFieldDelegate
        self.strongReferenceToDelegate = textFieldDelegate
        
        self.keyboardType = keyboardType
        
        font = theme.font
        textColor = theme.textColor
        
        leftViewMode = .always
        
        let container = UIView(frame: .zero)
        let imageView = UIImageView(image: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalToConstant: 30),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        leftView = container

        let sel = #selector(HeidelpayPaymentInfoTextField.handleTextDidChangeNotification)
        NotificationCenter.default.addObserver(self,
                                               selector: sel,
                                               name: UITextField.textDidChangeNotification,
                                               object: self)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: theme.font,
            NSAttributedString.Key.foregroundColor: theme.placeholderColor
        ]
        attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                   attributes: placeholderAttributes)

    }
    
    @objc func handleTextDidChangeNotification() {
        
    }
    
    func updateImage(image: UIImage?) {
        guard let imageView = self.leftView?.subviews.first as? UIImageView else {
            return
        }
        imageView.image = image?.heidelpay_resize(targetSize: imageTargetSize)
    }
    
    private var imageTargetSize: CGSize = CGSize(width: 20, height: 20)
    
    func setHasError() {
        updateImage(image: UIImage.heidelpay_resourceImage(named: "error"))
        textColor = theme.errorColor
    }
    
    func setIsValid() {
        updateImage(image: UIImage.heidelpay_resourceImage(named: "success"))
        textColor = theme.textColor
    }
}
