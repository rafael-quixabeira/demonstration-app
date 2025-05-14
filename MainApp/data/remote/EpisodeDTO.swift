//
//  EpisodeDTO.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 11/05/25.
//

import Foundation

struct EpisodeDTO: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [URL]
    let url: URL

    private enum CodingKeys: String, CodingKey {
        case id, name, episode, url, characters
        case airDate = "air_date"
    }
}
