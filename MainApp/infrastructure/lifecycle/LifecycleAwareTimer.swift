//
//  LifecycleAwareTimer.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 13/05/25.
//

import Foundation
import Combine

protocol LifecycleAwareTimerProtocol {
    var tick: AnyPublisher<Date, Never> { get }
}

final class LifecycleAwareTimer {
    private var timerCancellable: AnyCancellable?
    private var lifecycleCancellables: [AnyCancellable] = []

    private let lifecycleEvents: LifecycleEventsProtocol
    private let interval: TimeInterval
    private var tickSubject = PassthroughSubject<Date, Never>()

    init(interval: TimeInterval, lifecycleEvents: LifecycleEventsProtocol) {
        self.interval = interval
        self.lifecycleEvents = lifecycleEvents

        observeLifecycle()
    }

    private func observeLifecycle() {
        lifecycleEvents.willEnterForeground
            .sink { [weak self] in self?.startTimer() }
            .store(in: &lifecycleCancellables)

        lifecycleEvents.didEnterBackground
            .sink { [weak self] in self?.stopTimer() }
            .store(in: &lifecycleCancellables)

        startTimer()
    }

    private func startTimer() {
        stopTimer()

        timerCancellable = Timer.publish(
            every: interval,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] date in
            self?.tickSubject.send(date)
        }
    }

    private func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    deinit {
        stopTimer()
        lifecycleCancellables.forEach { $0.cancel() }
    }
}

extension LifecycleAwareTimer: LifecycleAwareTimerProtocol {
    var tick: AnyPublisher<Date, Never> {
        return tickSubject.eraseToAnyPublisher()
    }
}
