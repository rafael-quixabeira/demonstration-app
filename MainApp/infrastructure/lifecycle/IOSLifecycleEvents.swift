//
//  IOSLifecycleEvents.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 13/05/25.
//

import Combine
import UIKit

class IOSLifecycleEvents {
    private var cancellables: [AnyCancellable] = []

    private let didEnterBackgroundSubject = PassthroughSubject<Void, Never>()
    private let willEnterForegroundSubject = PassthroughSubject<Void, Never>()
    
    private let logger: LoggerProtocol

    init(logger: LoggerProtocol) {
        self.logger = logger
        self.observe()
    }

    private func observe() {
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.logger.info("ios app did enter background", category: .general)
                self?.didEnterBackgroundSubject.send(())
            }.store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.logger.info("ios app will enter background", category: .general)
                self?.willEnterForegroundSubject.send(())
            }.store(in: &cancellables)
    }
}

extension IOSLifecycleEvents: LifecycleEventsProtocol {
    var didEnterBackground: AnyPublisher<Void, Never> {
        didEnterBackgroundSubject.eraseToAnyPublisher()
    }
    
    var willEnterForeground: AnyPublisher<Void, Never> {
        willEnterForegroundSubject.eraseToAnyPublisher()
    }
}
