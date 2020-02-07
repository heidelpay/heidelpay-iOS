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

import Foundation
import PassKit

/// extension with methods to create payment types
extension Heidelpay {
    
    /// create a card payment type
    /// - Parameter number: credit card number
    /// - Parameter cvc: cvc number
    /// - Parameter expiryDate: expiry date of card in the format MM/YY
    /// - Parameter use3ds: flag to indicate if 3ds shall be used for this card on charge. (Depends on your contract).
    ///                     Default is true
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentCard(number: String, cvc: String, expiryDate: String, use3ds: Bool = true,
                                  completion: @escaping CreatePaymentCompletionBlock) {
        
        createPayment(type: CardPayment(number: number, cvc: cvc, expiryDate: expiryDate, use3ds: use3ds),
                      completion: completion)
    }
    
    /// create a Sepa Direct Debit payment type
    /// - Parameter iban: International bank account number (IBAN)
    /// - Parameter bic: Bank identification number (only needed for some countries) (optional)
    /// - Parameter holder: Name of the bank account (optional)
    /// - Parameter guaranteed: toggles if this is a guaranteed or non guaranteed sepa direct payment.
    ///                         Default is non guaranteed.
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentSepaDirect(iban: String, bic: String?, holder: String?,
                                        guaranteed: Bool = false,
                                        completion: @escaping CreatePaymentCompletionBlock) {
        
        createPayment(type: SepaDirectDebitPayment(iban: iban, bic: bic,
                                                   holder: holder, guaranteed: guaranteed),
                      completion: completion)
    }
    
    /// create an Invoice payment type
    /// - Parameter guaranteed: toggles if this is a guaranteed or non guaranteed invoice payment.
    ///                         Default is non guaranteed.
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentInvoice(guaranteed: Bool = false, completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: InvoicePayment(guaranteed: guaranteed), completion: completion)
    }
    
    /// create a Sofort Ueberweisung payment type
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentSofort(completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: SofortPayment(), completion: completion)
    }
    
    /// create a Giropay payment type
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentGiropay(completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: GiropayPayment(), completion: completion)
    }
    
    /// create a Prepayment payment type
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentPrepayment(completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: PrepaymentPayment(), completion: completion)
    }
    
    /// create a Przelewy24 payment type
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentPrzelewy24(completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: Przelewy24Payment(), completion: completion)
    }
    
    /// create a Paypal payment type
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentPaypal(completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: PaypalPayment(), completion: completion)
    }

    /// create a iDEAL payment type
    /// - Parameter bic: bic to use for this Ideal payment
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentIdeal(bic: String, completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: IdealPayment(bic: bic), completion: completion)
    }

    /// create an Apple Pay payment type
    /// - Parameter paymentToken: Payment Token of the Apple Pay transaction
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createApplePay(paymentToken: PKPaymentToken, completion: @escaping CreatePaymentCompletionBlock) {
        createApplePay(paymentTokenData: paymentToken.paymentData, completion: completion)        
    }
    
    /// create an Apple Pay payment type based on the payment token data for unit testing
    /// - Parameter paymentData: Payment Token data of the Apple Pay transaction
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createApplePay(paymentTokenData: Data, completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: ApplePayPayment(paymentTokenData: paymentTokenData), completion: completion)
    }

    /// create an Alipay payment type
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentAlipay(completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: AlipayPayment(), completion: completion)
    }
    
    /// create a WeChat payment type
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentWeChatPay(completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: WeChatPayPayment(), completion: completion)
    }

    /// create a PIS payment type
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentPIS(completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: PISPayment(), completion: completion)
    }

    /// create an Invoice-Factoring payment type
    /// - Parameter completion: completion handler of type CreatePaymentCompletionBlock.
    public func createPaymentInvoiceFactoring(completion: @escaping CreatePaymentCompletionBlock) {
        createPayment(type: InvoiceFactoringPayment(), completion: completion)
    }
    
}
