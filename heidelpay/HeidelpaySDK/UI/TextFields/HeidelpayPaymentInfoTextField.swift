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

// swiftlint:disable weak_delegate

/// base class for heidelpay UI components for entering
/// payment information.
public class HeidelpayPaymentInfoTextField: UITextField {
    
    private(set) var internalTextFieldDelegate: ChainingTextFieldDelegate = ChainingTextFieldDelegate()
    private weak var externalTextFieldDelegate: UITextFieldDelegate?
    
    var theme: HeidelpayTheme = .sharedInstance
    
    override public var delegate: UITextFieldDelegate? {
        didSet {
            if delegate == nil || !(delegate is ChainingTextFieldDelegate) {
                self.externalTextFieldDelegate = delegate
                super.delegate = internalTextFieldDelegate
                internalTextFieldDelegate.chainedDelegate = externalTextFieldDelegate
            }
        }
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
    
    func setup(placeHolder: String,
               internalDelegate: ChainingTextFieldDelegate,
               keyboardType: UIKeyboardType = .numberPad) {
        setInternalTextFieldDelegate(internalDelegate)
        
        super.delegate = internalTextFieldDelegate
        
        self.keyboardType = keyboardType
        
        font = theme.font
        textColor = theme.textColor

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
    
    func setInternalTextFieldDelegate(_ internalDelegate: ChainingTextFieldDelegate) {
        let chainedDelegate = internalTextFieldDelegate.chainedDelegate
        internalTextFieldDelegate = internalDelegate
        internalDelegate.chainedDelegate = chainedDelegate
    }
    
    @objc func handleTextDidChangeNotification() {
        
    }
}
