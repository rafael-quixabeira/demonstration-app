//
//  CacheProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

public protocol CacheProtocol {
    func get<T: Sendable>(_ key: CacheKey) async -> T?
    func set<T: Sendable>(_ key: CacheKey, _ value: T) async
    func remove(_ key: CacheKey) async

    func erase() async
}

public extension CacheProtocol {
    typealias FetchClosure<T: Sendable> = () async throws -> T

    func getOrFetch<T: Sendable>(_ key: CacheKey, fetch: @escaping FetchClosure<T>) async throws -> T {
        if let cached: T = await get(key) {
            return cached
        }

        let fresh = try await fetch()

        await set(key, fresh)
        return fresh
    }
}
