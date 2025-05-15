import Foundation

public class DummyHardcodedEnvs: Environment {
    public init() {}

    public var apiURL: URL {
        guard let url = URL(string: "https://rickandmortyapi.com/api") else {
            fatalError("Invalid hardcoded API URL")
        }

        return url
    }

    public var appEnvironment: String {
        #if DEBUG
        return "DEVELOPMENT"
        #else
        return "PRODUCTION"
        #endif
    }
} 
