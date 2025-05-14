//
//  CharacterPage.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

public struct PageInfo {
    public let count: Int
    public let pages: Int
}

public struct CharacterPage {
    public let info: PageInfo
    public let characters: [Characterr]
}
