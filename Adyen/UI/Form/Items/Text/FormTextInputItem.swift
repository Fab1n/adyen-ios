//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

/// An item for plain text input
/// :nodoc:
public final class FormTextInputItem: FormTextItem, Hidable {
    
    /// :nodoc:
    public var isHidden: Observable<Bool> = Observable(false)
        
    /// :nodoc:
    override public func build(with builder: FormItemViewBuilder) -> AnyFormItemView {
        builder.build(with: self)
    }
    
    public override init(style: FormTextItemStyle = FormTextItemStyle()) {
        super.init(style: style)
    }
    
    public override func isValid() -> Bool {
        isHidden.wrappedValue ? true : super.isValid()
    }
    
}
