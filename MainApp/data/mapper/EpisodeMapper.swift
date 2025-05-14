//
//  Episode.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

struct EpisodeMapper {
    static func toDomain(dto: EpisodeDTO) -> Episode {
        .init(
            id: dto.id.description,
            episode: dto.episode,
            name: dto.name,
            airDate: dto.airDate
        )
    }
}

extension EpisodeDTO {
    func toDomain() -> Episode {
        EpisodeMapper.toDomain(dto: self)
    }
}
