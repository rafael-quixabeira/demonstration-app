//
//  DummyLogger.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 14/05/25.
//

@testable import MainApp
import Infrastructure

final class DummyLogger: LoggerProtocol {
    func debug(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
    func info(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
    func notice(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
    func warning(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
    func error(_ message: String, category: LoggerCategory, file: String, function: String, line: Int) {}
}
