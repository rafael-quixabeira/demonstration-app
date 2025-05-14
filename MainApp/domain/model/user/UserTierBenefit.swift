//
//  UserTierBenefit.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation

enum UserTierBenefit: CaseIterable {
    case prefetching
    case cache
    case turbo

    var title: String {
        switch self {
        case .prefetching:
            return Strings.benefitPrefetchingTitle
        case .cache:
            return Strings.benefitCacheTitle
        case .turbo:
            return Strings.benefitTurboTitle
        }
    }

    var description: String {
        switch self {
        case .prefetching:
            return Strings.benefitPrefetchingDescription
        case .cache:
            return Strings.benefitCacheDescription
        case .turbo:
            return Strings.benefitTurboDescription
        }
    }
}
