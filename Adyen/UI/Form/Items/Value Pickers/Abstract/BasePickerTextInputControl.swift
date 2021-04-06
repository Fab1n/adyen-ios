//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import UIKit

internal protocol PickerTextInputControl: UIView {

    /// Executed when the view resigns as first responder.
    var onDidResignFirstResponder: (() -> Void)? { get set }

    /// Executed when the view becomes first responder.
    var onDidBecomeFirstResponder: (() -> Void)? { get set }

    /// Executed when the view detected tap.
    var onDidTap: (() -> Void)? { get set }

    /// Controls visibility of chevrone view.
    var showChevrone: Bool { get set }

    /// Selection value lebel text
    var label: String? { get set }
    
}

/// A control to select a phone extension from a list.
internal class BasePickerInputControl: UIControl, PickerTextInputControl {

    internal let style: TextStyle

    internal weak var delegate: FormItemViewDelegate?

    internal var childItemViews: [AnyFormItemView] = []

    internal lazy var chevronView = UIImageView(image: accessoryImage)

    internal var onDidResignFirstResponder: (() -> Void)?

    internal var onDidBecomeFirstResponder: (() -> Void)?

    internal var onDidTap: (() -> Void)?

    override internal var inputView: UIView? { _inputView }

    override internal var canBecomeFirstResponder: Bool { true }

    internal var accessoryImage: UIImage? { UIImage(named: "chevron_down",
                                                    in: Bundle.coreInternalResources,
                                                    compatibleWith: nil) }

    internal var _inputView: UIView // swiftlint:disable:this identifier_name

    internal var showChevrone: Bool {
        get { chevronView.isHidden }
        set { chevronView.isHidden = newValue }
    }

    internal var label: String? {
        get { valueLabel.text }
        set { valueLabel.text = newValue }
    }

    /// The phone code label.
    internal lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = style.backgroundColor
        label.textAlignment = style.textAlignment
        label.textColor = style.color
        label.font = style.font
        label.adjustsFontForContentSizeCategory = true

        return label
    }()

    override internal var accessibilityIdentifier: String? {
        didSet {
            valueLabel.accessibilityIdentifier = accessibilityIdentifier.map {
                ViewIdentifierBuilder.build(scopeInstance: $0, postfix: "label")
            }
        }
    }

    // MARK: PickerTextInputControl protocol

    /// Initializes a `PhoneExtensionInputControl`.
    ///
    /// - Parameter inputView: The input view used in place of the system keyboard.
    /// - Parameter style: The UI style.
    internal init(inputView: UIView, style: TextStyle) {
        _inputView = inputView
        self.style = style
        super.init(frame: CGRect.zero)

        setupView()
        addTarget(self, action: #selector(self.handleTapAction), for: .touchUpInside)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// :nodoc:
    override internal func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        onDidResignFirstResponder?()
        return result
    }

    /// :nodoc:
    override internal func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        onDidBecomeFirstResponder?()
        return result
    }

    // MARK: - Private

    /// The stack view.
    open func setupView() {
        preconditionFailure("This is abstract class")
    }

    @objc
    private func handleTapAction() {
        onDidTap?()
    }

}
