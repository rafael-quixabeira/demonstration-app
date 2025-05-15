//
//  LifecycleEventsProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 13/05/25.
//

import Combine
import Foundation

public protocol LifecycleEventsProtocol {
    var didEnterBackground: AnyPublisher<Void, Never> { get }
    var willEnterForeground: AnyPublisher<Void, Never> { get }
}

public extension LifecycleEventsProtocol {
    func buildLifecycleAwareTimer(interval: TimeInterval) -> LifecycleAwareTimer {
        LifecycleAwareTimer(interval: interval, lifecycleEvents: self)
    }
}
