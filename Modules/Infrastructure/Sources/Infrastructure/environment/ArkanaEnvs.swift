import Foundation
import ArkanaKeys
import ArkanaKeysInterfaces

public class ArkanaEnvs {
    private let globalKeys = Keys.Global()

    private let environmentKeys: any KeysEnvironmentProtocol = {
        #if DEBUG
        return Keys.Debug()
        #else
        return Keys.Release()
        #endif
    }()
} 

extension ArkanaEnvs: Environment {
    public var apiURL: URL {
        guard
            let url = URL(string: "https://\(globalKeys.apiUrl)")
        else {
            fatalError("Invalid API_URL in Arkana environment variables")
        }
        return url
    }

    public var appEnvironment: String {
        environmentKeys.appEnv
    }
}
