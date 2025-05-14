//
//  Data+Extensions.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Foundation

extension Data {
    func jsonDecode<T: Decodable>(as type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: self)
    }
}
