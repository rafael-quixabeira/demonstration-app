//
//  UserStreamProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import Combine

public protocol UserStreamProtocol {
    var user: AnyPublisher<User?, Never> { get }
}

public protocol MutableUserStreamProtocol: UserStreamProtocol {
    func updateUser(_ user: User?)
}
