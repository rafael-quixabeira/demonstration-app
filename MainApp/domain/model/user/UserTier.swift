//
//  UserTier.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation

enum UserTier: String, CaseIterable {
    case free
    case premium
    case vip

    var localizedName: String {
        switch self {
        case .free:
            return NSLocalizedString("tier-free", comment: "")
        case .premium:
            return NSLocalizedString("tier-premium", comment: "")
        case .vip:
            return NSLocalizedString("tier-vip", comment: "")
        }
    }

    var benefits: Set<UserTierBenefit> {
        switch self {
        case .free:
            [.prefetching]
        case .premium:
            [.prefetching, .cache]
        case .vip:
            [.prefetching, .cache, .turbo]
        }
    }
}
