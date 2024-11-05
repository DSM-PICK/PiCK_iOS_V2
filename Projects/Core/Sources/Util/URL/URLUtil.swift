import Foundation

public struct URLUtil {}

public extension URLUtil {
    static let baseURL: URL = URL(
        string: Bundle.main.object(
            forInfoDictionaryKey: "API_BASE_URL"
        ) as? String ?? "") ?? URL(string: "")!

    static let socketBaseURL: String = Bundle.main.object(
        forInfoDictionaryKey: "SOCKET_BASE_URL"
    ) as? String ?? ""

}
