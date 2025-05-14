//
//  Logger.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

import Foundation
import os

final class OSLogger: LoggerProtocol {
    private let subsystem: String

    init(subsystem: String = Bundle.main.bundleIdentifier ?? "br.com.rafael.mainApp") {
        self.subsystem = subsystem
    }

    private func getLogger(for category: LoggerCategory) -> Logger {
        Logger(subsystem: subsystem, category: category.rawValue)
    }

    private func composeMessage(
        _ message: String,
        file: String,
        function: String,
        line: Int
    ) -> String {
        let fileName = (file as NSString).lastPathComponent
        return "[\(fileName):\(line)] \(function) — \(message)"
    }

    func debug(
        _ message: String,
        category: LoggerCategory,
        file: String,
        function: String,
        line: Int
    ) {
        let logger = getLogger(for: category)
        logger.debug("\(self.composeMessage(message, file: file, function: function, line: line), privacy: .public)")
    }

    func info(
        _ message: String,
        category: LoggerCategory,
        file: String,
        function: String, line: Int) {
        let logger = getLogger(for: category)
        logger.info("\(self.composeMessage(message, file: file, function: function, line: line), privacy: .public)")
    }

    func notice(
        _ message: String,
        category: LoggerCategory,
        file: String,
        function: String,
        line: Int
    ) {
        let logger = getLogger(for: category)
        logger.notice("\(self.composeMessage(message, file: file, function: function, line: line), privacy: .public)")
    }

    func warning(
        _ message: String,
        category: LoggerCategory,
        file: String,
        function: String,
        line: Int
    ) {
        let logger = getLogger(for: category)
        logger.warning("\(self.composeMessage(message, file: file, function: function, line: line), privacy: .public)")
    }

    func error(
        _ message: String,
        category: LoggerCategory,
        file: String,
        function: String,
        line: Int
    ) {
        let logger = getLogger(for: category)
        logger.error("\(self.composeMessage(message, file: file, function: function, line: line), privacy: .public)")
    }
}
