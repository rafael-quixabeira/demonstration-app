//
//  APIError.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case invalidRequestBody
    case invalidResponse
    case unexpectedStatusCode(Int, Data)
    case invalidResponseData
}
