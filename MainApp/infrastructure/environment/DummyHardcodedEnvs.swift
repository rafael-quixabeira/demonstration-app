import Foundation

final class DummyHardcodedEnvs: Environment {
    var apiURL: URL {
        guard let url = URL(string: "https://rickandmortyapi.com/api") else {
            fatalError("Invalid hardcoded API URL")
        }
        return url
    }

    var appEnvironment: String {
        #if DEBUG
        return "DEVELOPMENT"
        #else
        return "PRODUCTION"
        #endif
    }
} 
