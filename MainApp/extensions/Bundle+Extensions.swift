import Foundation

extension Bundle {
    var baseURL: URL {
        guard
            let baseURL = object(forInfoDictionaryKey: "BASE_URL") as? String,
            !baseURL.isEmpty,
            let url = URL(string: "https://\(baseURL)")
        else {
            fatalError("BASE_URL must be set in either Info.plist or environment variables")
        }

        return url
    }
} 
