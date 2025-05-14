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
            return Strings.tierFree
        case .premium:
            return Strings.tierPremium
        case .vip:
            return Strings.tierVip
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

    var title: String {
        switch self {
        case .free:
            return Strings.tierFree
        case .premium:
            return Strings.tierPremium
        case .vip:
            return Strings.tierVip
        }
    }
}
