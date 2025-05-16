//
//  UserStreamProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import Combine

/// @mockable
public protocol UserStreamProtocol {
    var user: AnyPublisher<User?, Never> { get }
}

/// @mockable
public protocol MutableUserStreamProtocol: UserStreamProtocol {
    func updateUser(_ user: User?)
}
