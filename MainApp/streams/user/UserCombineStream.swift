//
//  UserCombineStream.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import Combine

class UserCombineStream {
    private let stream = CurrentValueSubject<User?, Never>(nil)
}

extension UserCombineStream: UserStreamProtocol {
    var user: AnyPublisher<User?, Never> {
        stream.eraseToAnyPublisher()
    }
}

extension UserCombineStream: MutableUserStreamProtocol {
    func updateUser(_ user: User?) {
        self.stream.send(user)
    }
}
