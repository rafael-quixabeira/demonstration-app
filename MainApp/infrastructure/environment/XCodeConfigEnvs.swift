import Foundation

final class XCodeConfigEnvs: Environment {
    var apiURL: URL {
        guard
            let baseURL = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String,
            !baseURL.isEmpty,
            let url = URL(string: "https://\(baseURL)")
        else {
            fatalError("API_URL must be set in Info.plist")
        }

        return url
    }

    var appEnvironment: String {
        guard
            let environment = Bundle.main.object(forInfoDictionaryKey: "APP_ENV") as? String,
            !environment.isEmpty
        else {
            fatalError("APP_ENV must be set in Info.plist")
        }

        return environment
    }
} 