//
//  LifecycleEventsProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 13/05/25.
//

import Combine
import Foundation

protocol LifecycleEventsProtocol {
    var didEnterBackground: AnyPublisher<Void, Never> { get }
    var willEnterForeground: AnyPublisher<Void, Never> { get }
}

extension LifecycleEventsProtocol {
    public func buildLifecycleAwareTimer(interval: TimeInterval) -> LifecycleAwareTimer {
        LifecycleAwareTimer(interval: interval, lifecycleEvents: self)
    }
}
