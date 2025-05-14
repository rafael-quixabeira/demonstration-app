//
//  CacheKey.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Foundation

enum CacheKey: Hashable {
    case characters(String)
    case character(String)
    case episode(String)

    var identifier: String {
        String(reflecting: self)
    }

    var ttl: TimeInterval {
        switch self {
        case .characters:
            return 1.minutes
        case .character:
            return 5.minutes
        case .episode:
            return 1.hours
        }
    }
}
