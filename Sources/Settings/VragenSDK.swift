import Foundation

public class VragenSDK {
    let server: URL
    let token: String

    private init(server: URL, token: String) {
        self.server = server
        self.token = token
    }

    static var settings: VragenSDK? = nil

    public static func set(server: URL, token: String) {
        settings = VragenSDK(server: server, token: token)
    }
}
