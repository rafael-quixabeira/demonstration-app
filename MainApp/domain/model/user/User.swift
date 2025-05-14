//
//  User.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import Foundation

public struct User {
    let username: String
    let tier: UserTier
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.username == rhs.username
    }
}
