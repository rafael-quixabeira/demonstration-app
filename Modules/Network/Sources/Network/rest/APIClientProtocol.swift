//
//  APIClient.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

public protocol APIClientProtocol {
    func perform<T: Decodable>(api request: HTTPAPIRequest) async throws -> T
}
