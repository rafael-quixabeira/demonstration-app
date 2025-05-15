//
//  HTTPAPIClient.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Foundation
import Infrastructure

public class HTTPAPIClient {
    private let baseURL: URL
    private let logger: LoggerProtocol

    public init(baseURL: URL, logger: LoggerProtocol) {
        self.baseURL = baseURL
        self.logger = logger
    }

    private func buildRequest(request: HTTPAPIRequest) throws -> URLRequest {
        guard var components = URLComponents(string: "\(baseURL)\(request.path)") else {
            throw APIError.invalidURL
        }

        if let query = request.query {
            components.queryItems = query.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
        }

        guard  let url = components.url else {
            throw APIError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = ["Content-Type": request.contentType]

        if let body = request.body {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                logger.error("an error happened while serializing the request body \(error)", category: .networking)
                throw APIError.invalidRequestBody
            }
        }

        return urlRequest
    }
}

extension HTTPAPIClient: APIClientProtocol {
    public func perform<T>(api request: HTTPAPIRequest) async throws -> T where T : Decodable {
        let urlRequest = try buildRequest(request: request)

        logger.info("performing request \(urlRequest)", category: .networking)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.unexpectedStatusCode(httpResponse.statusCode, data)
        }
        
        try await Task.sleep(for: .seconds(request.delay))

        do {
            return try data.jsonDecode(as: T.self)
        } catch {
            logger.error("an error happened while decoding the response data for type:\(T.self) error:\(error).", category: .networking)
            throw APIError.invalidResponseData
        }
    }
}
