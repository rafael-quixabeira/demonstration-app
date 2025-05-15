//
//  InMemoryCache.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Foundation

public actor InMemoryCache {
    typealias CacheValue = (value: Any, expiration: Date)
    private var storage: Dictionary<CacheKey, CacheValue> = .init()
    private let logger: LoggerProtocol

    public init(logger: LoggerProtocol) {
        self.logger = logger
    }
}

extension InMemoryCache: CacheProtocol {
    public func get<T: Sendable>(_ key: CacheKey) async -> T? {
        guard let entry = storage[key], Date.now <= entry.expiration else {
//            logger.info("❌ cache miss for "\(key.identifier)"", category: .cache)
            return nil
        }

        return entry.value as? T
    }

    public func set<T: Sendable>(_ key: CacheKey, _ value: T) async {
        let expiration = Date().addingTimeInterval(key.ttl)
        storage[key] = (value, expiration)

//        logger.info("✅ cached "\(key.identifier)" até \(expiration)", category: .cache)
    }

    public func remove(_ key: CacheKey) async {
        storage.removeValue(forKey: key)
//        logger.info("✅ removed "\(key.identifier)", category: .cache)
    }

    public func erase() async {
        storage = [:]
//        logger.info("✅ erased all cached values", category: .cache)
    }
}
