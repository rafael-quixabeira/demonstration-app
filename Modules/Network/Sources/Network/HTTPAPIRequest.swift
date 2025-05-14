//
//  HTTPAPIRequest.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

// https://rickandmortyapi.com/documentation/#character-schema
// https://rickandmortyapi.com/documentation/#filter-characters

import Foundation

public enum HTTPAPIRequest {
    case list(query: KeyValuePairs<String, String>)
    case detail(id: String)
    case episode(id: String)

    public var path: String {
        switch self {
        case .list:
            return "/character"
        case .detail(let id):
            return "/character/\(id)"
        case .episode(let id):
            return "/episode/\(id)"
        }
    }

    public var query: KeyValuePairs<String, String>? {
        switch self {
        case .list(let query):
            return query
        default:
            return nil
        }
    }

    public var body: Encodable? {
        nil
    }

    public var method: HTTPMethod {
        return .get
    }

    public var contentType: String {
        return "application/json"
    }
    
    public var delay: TimeInterval {
        switch self {
        case .episode:
            return 1.seconds
        default:
            return 0.seconds
        }
    }
}
