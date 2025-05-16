import Foundation

/// @mockable
public protocol Environment {
    var apiURL: URL { get }
    var appEnvironment: String { get }
} 
