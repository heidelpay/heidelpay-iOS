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

/// Hire Purchase Installment Rate
/// Holds the values of an individual rate and belongs to Hire Purchase Plan
public struct HirePurchaseInstallmentRate: Decodable {
    public let amountOfRepayment: Float
    public let rate: Float
    public let totalRemainingAmount: Float
    public let type: String
    public let rateIndex: Int
    public let ultimo: Bool
}

/// Hire Purchase Installment Plan
public struct HirePurchasePlan: Decodable {
    public let numberOfRates: Int
    public let dayOfPurchase: String
    public let totalPurchaseAmount: Decimal
    public let totalInterestAmount: Decimal
    public let totalAmount: Decimal
    public let effectiveInterestRate: Decimal
    public let nominalInterestRate: Decimal
    public let feeFirstRate: Decimal
    public let feePerRate: Decimal
    public let monthlyRate: Decimal
    public let lastRate: Decimal
    public let installmentRates: [HirePurchaseInstallmentRate]
}

/// Hire Purchase Payment Type
struct HirePurchasePayment: CreatePaymentType, Codable {
    var method: PaymentMethod { return .hirePurchase }
    
    /// International bank account number (IBAN)
    let iban: String
    /// Bank identification number
    let bic: String
    /// Name of the bank account
    let holder: String
    
    // Other properties are mapped from the provided plan
    let numberOfRates: Int
    let effectiveInterestRate: Decimal
    let nominalInterestRate: Decimal
    let totalPurchaseAmount: Decimal
    let totalInterestAmount: Decimal
    let totalAmount: Decimal
    let feeFirstRate: Decimal
    let feePerRate: Decimal
    let monthlyRate: Decimal
    let lastRate: Decimal
    let dayOfPurchase: String
    
    /// Init HirePurchase Payment
    /// - Parameter iban: International bank account number (IBAN)
    /// - Parameter bic: Bank identification number
    /// - Parameter holder: Name of the bank account
    /// - Parameter plan: Hire purchase plan
    init(iban: String, bic: String, holder: String, plan: HirePurchasePlan) {
        self.iban = iban
        self.bic = bic
        self.holder = holder
        
        self.numberOfRates = plan.numberOfRates
        self.effectiveInterestRate = HirePurchasePayment.roundedTo2Commas(plan.effectiveInterestRate)
        self.nominalInterestRate = HirePurchasePayment.roundedTo2Commas(plan.nominalInterestRate)
        self.totalPurchaseAmount = HirePurchasePayment.roundedTo2Commas(plan.totalPurchaseAmount)
        self.totalInterestAmount = HirePurchasePayment.roundedTo2Commas(plan.totalInterestAmount)
        self.totalAmount = HirePurchasePayment.roundedTo2Commas(plan.totalAmount)
        self.feeFirstRate = HirePurchasePayment.roundedTo2Commas(plan.feeFirstRate)
        self.feePerRate = HirePurchasePayment.roundedTo2Commas(plan.feePerRate)
        self.monthlyRate = HirePurchasePayment.roundedTo2Commas(plan.monthlyRate)
        self.lastRate = HirePurchasePayment.roundedTo2Commas(plan.lastRate)
        self.dayOfPurchase = plan.dayOfPurchase
    }
    
    private static func roundedTo2Commas(_ value: Decimal) -> Decimal {
        var decimal = value
        var rounded = Decimal()
        NSDecimalRound(&rounded, &decimal, 2, .bankers)
        return rounded
    }
}
