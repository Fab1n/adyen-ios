//
// Copyright (c) 2023 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Foundation

/// This is excluded from the normal xcode project file,
/// and used only when built with Swift Package Manager,
/// since swift packages has different code to access internal resources,
/// that doesn't compile in a normal xcode project.
/// The Bundle extension in `BundleExtension.swift` is used instead.
@_spi(AdyenInternal)
extension Bundle {

    /// The main bundle of the framework.
    internal static let core: Bundle = .init(for: FormView.self)

    /// The bundle in which the framework's resources are located.
    public static let coreInternalResources: Bundle = .module
}
