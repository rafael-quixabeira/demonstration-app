//
//  CacheKey.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Foundation

public enum CacheKey: Hashable, Sendable {
    case characters(String)
    case character(String)
    case episode(String)

    public var identifier: String {
        String(reflecting: self)
    }

    public var ttl: TimeInterval {
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

extension Int {
    var seconds: TimeInterval { TimeInterval(self) }
    var minutes: TimeInterval { TimeInterval(self) * 60 }
    var hours:   TimeInterval { TimeInterval(self) * 3600 }
    var days:    TimeInterval { TimeInterval(self) * 86400 }
}
