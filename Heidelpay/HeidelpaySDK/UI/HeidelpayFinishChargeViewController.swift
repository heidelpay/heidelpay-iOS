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
import WebKit

/// Delegate for the Finish Charge View Controller
public protocol HeidelpayFinishChargeViewControllerDelegate: class {
    
    /// delegate method called when the the payment specific payment UI has finished
    /// or the user canceled the process. You should than dismiss the heidelpay view controller
    /// *Note:* You have to check the status your backend to get the current state of the payment!
    ///
    /// - Parameter canceledByUser: true if the user canceled the process by tapping the cancel button. This does not
    ///                             necessarily indicate that the payment was canceled. You have to check the state from
    ///                             your server!
    /// - Parameter heidelPayController: heidelpay view controller that called the delegate method
    func heidelpayChargeViewControllerDidFinish(canceledByUser: Bool,
                                                heidelPayController: HeidelpayFinishChargeViewController)
}

/// View Controller for handling pending charges where the user
/// must confirm the payment with a specific (web) UI.
///
/// If you put the View Controller in a UINavigationViewController a cancel button will be shown
/// as left bar button item which triggers the HeidelpayFinishChargeViewControllerDelegate
public class HeidelpayFinishChargeViewController: UIViewController {

    /// delegate
    private weak var delegate: HeidelpayFinishChargeViewControllerDelegate?
    /// redirect URL that is being displayed
    private var redirectURL: URL
    /// return URL that is listened for
    private var returnURL: URL
    
    /// Init the Heidelpay Finish Charge View Controller
    /// - Parameter delegate: Delegate that is informed when the view controller has finished
    /// - Parameter redirectURL: Redirect URL as obtained on the server side from the charge request
    /// - Parameter returnURL: Return URL as obtained on the server side from the charge request
    public init(delegate: HeidelpayFinishChargeViewControllerDelegate, redirectURL: URL, returnURL: URL) {
        self.delegate = delegate
        self.redirectURL = redirectURL
        self.returnURL = returnURL
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Payment"
        
        view.backgroundColor = UIColor.white
        
        let actionSel = #selector(HeidelpayFinishChargeViewController.cancelPaymentRedirection(_:))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: actionSel)
        
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self

        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        let layoutGuide = self.viewLayoutGuide
        NSLayoutConstraint.activate([
            webView.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor),
            webView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            webView.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
            ])
        
        webView.load(URLRequest(url: redirectURL))
    }
    
    private var viewLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide
        } else {
            let layoutGuideId = "ft_safeAreaLayoutGuide"
            
            if let layoutGuide = view.layoutGuides.filter({ $0.identifier == layoutGuideId }).first {
                return layoutGuide
            } else {
                let layoutGuide = UILayoutGuide()
                layoutGuide.identifier = layoutGuideId
                view.addLayoutGuide(layoutGuide)
                layoutGuide.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
                layoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
                layoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
                layoutGuide.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
                return layoutGuide
            }
        }
    }
    
    @objc private func cancelPaymentRedirection(_ sender: Any) {
        delegate?.heidelpayChargeViewControllerDidFinish(canceledByUser: true, heidelPayController: self)
    }
}

/// extension for WKWebView delegate
extension HeidelpayFinishChargeViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        if let requestURLString = navigationAction.request.url?.absoluteString {
            if requestURLString.starts(with: returnURL.absoluteString) {
                
                decisionHandler(.cancel)
                
                DispatchQueue.main.async {
                    delegate.heidelpayChargeViewControllerDidFinish(canceledByUser: false, heidelPayController: self)
                }
                
                return
            }
        }
        decisionHandler(.allow)
    }
}
