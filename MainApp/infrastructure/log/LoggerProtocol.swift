//
//  LoggerProtocol.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 09/05/25.
//

protocol LoggerProtocol {
    func debug(_ message: String, category: LoggerCategory, file: String, function: String, line: Int)
    func info(_ message: String, category: LoggerCategory, file: String, function: String, line: Int)
    func notice(_ message: String, category: LoggerCategory, file: String, function: String, line: Int)
    func warning(_ message: String, category: LoggerCategory, file: String, function: String, line: Int)
    func error(_ message: String, category: LoggerCategory, file: String, function: String, line: Int)
}

extension LoggerProtocol {
    func debug(
        _ message: String,
        category: LoggerCategory = .general,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        debug(message, category: category, file: file, function: function, line: line)
    }

    func info(
        _ message: String,
        category: LoggerCategory = .general,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        info(message, category: category, file: file, function: function, line: line)
    }

    func notice(
        _ message: String,
        category: LoggerCategory = .general,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        notice(message, category: category, file: file, function: function, line: line)
    }

    func warning(
        _ message: String,
        category: LoggerCategory = .general,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        warning(message, category: category, file: file, function: function, line: line)
    }

    func error(
        _ message: String,
        category: LoggerCategory = .general,
        file: String = #fileID,
        function: String = #function,
        line: Int = #line
    ) {
        error(message, category: category, file: file, function: function, line: line)
    }
}
