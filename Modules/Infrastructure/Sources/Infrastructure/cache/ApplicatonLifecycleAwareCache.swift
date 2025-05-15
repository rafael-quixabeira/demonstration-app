//
//  LifecycleAwareCache.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 13/05/25.
//

import Foundation
import Combine
import UIKit

public actor ApplicatonLifecycleAwareCache: AnyObject {
    private var cancellables: [AnyCancellable] = []

    private let logger: LoggerProtocol
    private let lifecycleEvents: LifecycleEventsProtocol

    private let cache = NSCache<NSString, ValueWrapper>()

    private var cacheKeys = Set<String>()

    public init(logger: LoggerProtocol, lifecycleEvents: LifecycleEventsProtocol) {
        self.logger = logger
        self.lifecycleEvents = lifecycleEvents

        Task { await self.observe() }
    }

    private func observe() {
        lifecycleEvents.didEnterBackground.sink { _ in
            Task { [weak self] in 
//                await self?.logger.info("❌ entering background, erasing cache", category: .cache)
                await self?.erase()
            }
        }.store(in: &cancellables)

        lifecycleEvents.buildLifecycleAwareTimer(interval: 1.minutes).tick.sink(receiveValue: { _ in
            Task { [weak self] in
//                await self?.logger.info("❌ removing expired cache items", category: .cache)
                await self?.removeExpiredItems()
            }
        }).store(in: &cancellables)
    }

    private func removeExpiredItems() {
        let now = Date()
        let keys = cacheKeys

        for key in keys {
            guard let wrapper = cache.object(forKey: key as NSString) else {
//                self.logger.info(
//                    "❌ key item \(key) is not in the cache which means was removed by NSCache's eviction system. Removing from keys set",
//                    category: .general
//                )
                
                deleteCacheEntry(forKey: key)
                continue
            }

            if now > wrapper.expirationDate {
                deleteCacheEntry(forKey: key)
            }
        }
    }

    private func deleteCacheEntry(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        cacheKeys.remove(key)

//        logger.info("🗑️ removed cache for “\(key)”", category: .cache)
    }
}

extension ApplicatonLifecycleAwareCache: CacheProtocol {
    public func get<T: Sendable>(_ key: CacheKey) async -> T? {
        guard let wrapper = cache.object(forKey: key.identifier as NSString) else {
            return nil
        }

        if Date() > wrapper.expirationDate {
            deleteCacheEntry(forKey: key.identifier)
            return nil
        }

        return wrapper.value as? T
    }

    public func set<T: Sendable>(_ key: CacheKey, _ value: T) async {
        let identifier = key.identifier

        cache.setObject(.init(value: value, ttl: key.ttl), forKey: identifier as NSString)
        cacheKeys.insert(identifier)
    }

    public func remove(_ key: CacheKey) async {
        let identifier = key.identifier

        deleteCacheEntry(forKey: identifier)
    }

    public func erase() async {
        cache.removeAllObjects()
        cacheKeys.removeAll()

        logger.notice("🧹 cache clean up", category: .cache)
    }
}

extension ApplicatonLifecycleAwareCache {
    private class ValueWrapper {
        let value: Any
        let expirationDate: Date

        init(value: Any, ttl: TimeInterval) {
            self.value = value
            self.expirationDate = Date().addingTimeInterval(ttl)
        }
    }
}
