//
//  WrapperCharacterDTO.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation

struct WrapperCharacterDTO: Decodable {
    let info: InfoDTO
    let results: [CharacterDTO]

    struct InfoDTO: Decodable {
        let count: Int
        let pages: Int
    }

    private enum CodingKeys: String, CodingKey {
        case info
        case results
    }
}

public struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: OriginDTO?
    let location: LocationDTO?
    let image: URL
    let episode: [URL]
    let url: URL

    private enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender
        case origin, location
        case image, episode, url
    }

    struct OriginDTO: Decodable {
        let name: String
        let url: String
    }

    struct LocationDTO: Decodable {
        let name: String
        let url: String
    }
}
