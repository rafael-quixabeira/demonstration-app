//
//  CharacterMapper.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

import Foundation

struct CharacterMapper {
    static func page(from wrapper: WrapperCharacterDTO) -> CharacterPage {
        let info = PageInfo(
          count: wrapper.info.count,
          pages: wrapper.info.pages
        )

        let chars = wrapper.results.map { toDomain($0) }

        return CharacterPage(
            info: info,
            characters: chars
        )
    }

    static func toDomain(_ dto: CharacterDTO) -> Character {
        .init(
            id: dto.id.description,
            name: dto.name,
            origin: dto.origin?.name,
            status: .init(rawValue: dto.status.lowercased()) ?? .unknown,
            species: dto.species,
            image: dto.image,
            episodes: dto.episode
        )
    }
}

extension WrapperCharacterDTO {
    func toDomain() -> CharacterPage {
        CharacterMapper.page(from: self)
    }
}
