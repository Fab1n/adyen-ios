//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

/**
 A collection of available payment methods.

 - SeeAlso:
 [API Reference](https://docs.adyen.com/api-explorer/#/CheckoutService/latest/post/paymentMethods__section_resParams)
 */
public struct PaymentMethods: Decodable {

    /// The already paid payment methods, in case of partial payments.
    public var paid: [PaymentMethod] = []
    
    /// The regular payment methods.
    public private(set) var regular: [PaymentMethod]
    
    /// The stored payment methods.
    public var stored: [StoredPaymentMethod]
    
    /// Initializes the PaymentMethods.
    ///
    /// - Parameters:
    ///   - regular: An array of the regular payment methods.
    ///   - stored: An array of the stored payment methods.
    public init(regular: [PaymentMethod], stored: [StoredPaymentMethod]) {
        self.regular = regular
        self.stored = stored
    }
    
    /// Override the title of any payment method shown in DropIn
    ///
    /// - Parameters:
    ///   - paymentMethodType: The payment method type for which to override its title.
    ///   - displayInformation: The `displayInformation` to use instead of the default one.
    public mutating func overrideDisplayInformation(ofPaymentMethod paymentMethodType: PaymentMethodType,
                                                    with displayInformation: MerchantCustomDisplayInformation) {
        for (index, paymentMethod) in regular.enumerated() where paymentMethod.type == paymentMethodType {
            regular[index].merchantProvidedDisplayInformation = displayInformation
        }
    }
    
    /// Returns the first available payment method of the given type.
    ///
    /// - Parameter type: The type of payment method to retrieve.
    /// - Returns: The first available payment method of the given type, or `nil` if none could be found.
    public func paymentMethod<T: PaymentMethod>(ofType type: T.Type) -> T? {
        regular.first { $0 is T } as? T
    }
    
    /// Returns the first available payment method of the given type.
    ///
    /// - Parameter type: The `PaymentMethodType` of payment method to retrieve.
    /// - Returns: The first available payment method of the given type, or `nil` if none could be found.
    public func paymentMethod(ofType type: PaymentMethodType) -> PaymentMethod? {
        regular.first { $0.type == type }
    }
    
    // MARK: - Decoding
    
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.regular = try container.decode([AnyPaymentMethod].self, forKey: .regular).compactMap(\.value)
        
        if try container.containsValue(.stored) {
            self.stored = try container.decode([AnyPaymentMethod].self, forKey: .stored).compactMap { $0.value as? StoredPaymentMethod }
        } else {
            self.stored = []
        }
    }
    
    internal enum CodingKeys: String, CodingKey {
        case regular = "paymentMethods"
        case stored = "storedPaymentMethods"
    }
    
}

internal enum AnyPaymentMethod: Decodable {
    case storedInstant(StoredInstantPaymentMethod)
    case storedCard(StoredCardPaymentMethod)
    case storedPayPal(StoredPayPalPaymentMethod)
    case storedBCMC(StoredBCMCPaymentMethod)
    case storedBlik(StoredBLIKPaymentMethod)

    case instant(PaymentMethod)
    case card(AnyCardPaymentMethod)
    case issuerList(IssuerListPaymentMethod)
    case sepaDirectDebit(SEPADirectDebitPaymentMethod)
    case bacsDirectDebit(BACSDirectDebitPaymentMethod)
    case achDirectDebit(ACHDirectDebitPaymentMethod)
    case applePay(ApplePayPaymentMethod)
    case qiwiWallet(QiwiWalletPaymentMethod)
    case weChatPay(WeChatPayPaymentMethod)
    case mbWay(MBWayPaymentMethod)
    case blik(BLIKPaymentMethod)
    case giftcard(GiftCardPaymentMethod)
    case doku(DokuPaymentMethod)
    case sevenEleven(SevenElevenPaymentMethod)
    case econtextStores(EContextPaymentMethod)
    case econtextATM(EContextPaymentMethod)
    case econtextOnline(EContextPaymentMethod)
    case boleto(BoletoPaymentMethod)
    case affirm(AffirmPaymentMethod)
    case atome(AtomePaymentMethod)
    
    case none
    
    internal var value: PaymentMethod? {
        switch self {
        case let .storedCard(paymentMethod):
            return paymentMethod
        case let .storedPayPal(paymentMethod):
            return paymentMethod
        case let .storedBCMC(paymentMethod):
            return paymentMethod
        case let .instant(paymentMethod):
            return paymentMethod
        case let .storedInstant(paymentMethod):
            return paymentMethod
        case let .card(paymentMethod):
            return paymentMethod
        case let .issuerList(paymentMethod):
            return paymentMethod
        case let .sepaDirectDebit(paymentMethod):
            return paymentMethod
        case let .bacsDirectDebit(paymentMethod):
            return paymentMethod
        case let .achDirectDebit(paymentMethod):
            return paymentMethod
        case let .applePay(paymentMethod):
            return paymentMethod
        case let .qiwiWallet(paymentMethod):
            return paymentMethod
        case let .weChatPay(paymentMethod):
            return paymentMethod
        case let .mbWay(paymentMethod):
            return paymentMethod
        case let .blik(paymentMethod):
            return paymentMethod
        case let .storedBlik(paymentMethod):
            return paymentMethod
        case let .doku(paymentMethod):
            return paymentMethod
        case let .giftcard(paymentMethod):
            return paymentMethod
        case let .sevenEleven(paymentMethod):
            return paymentMethod
        case let .econtextStores(paymentMethod):
            return paymentMethod
        case let .econtextATM(paymentMethod):
            return paymentMethod
        case let .econtextOnline(paymentMethod):
            return paymentMethod
        case let .boleto(paymentMethod):
            return paymentMethod
        case let .affirm(paymentMethod):
            return paymentMethod
        case let .atome(paymentMethod):
            return paymentMethod

        case .none:
            return nil
        }
    }
    
    // MARK: - Decoding
    
    internal init(from decoder: Decoder) throws {
        self = AnyPaymentMethodDecoder.decode(from: decoder)
    }
    
    internal enum CodingKeys: String, CodingKey {
        case type
        case details
        case brand
        case issuers
    }
}
