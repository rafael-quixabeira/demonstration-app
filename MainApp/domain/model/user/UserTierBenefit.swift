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
            return NSLocalizedString("benefit-prefetching-title", comment: "")
        case .cache:
            return NSLocalizedString("benefit-cache-title", comment: "")
        case .turbo:
            return NSLocalizedString("benefit-turbo-title", comment: "")
        }
    }

    var description: String {
        switch self {
        case .prefetching:
            return NSLocalizedString("benefit-prefetching-description", comment: "")
        case .cache:
            return NSLocalizedString("benefit-cache-description", comment: "")
        case .turbo:
            return NSLocalizedString("benefit-turbo-description", comment: "")
        }
    }
}
