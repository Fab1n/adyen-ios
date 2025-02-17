//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import Adyen3DS2
import Foundation

internal protocol AnyChallengeResult {

    var transactionStatus: String { get }
}

extension ADYChallengeResult: AnyChallengeResult {}
