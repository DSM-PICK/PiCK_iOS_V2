import Foundation
import Moya

public enum MenuBarAPI {
    case login(accountID: String, password: String)
    case refreshToken
    case fetchSchoolMeal(date: String)
}

extension MenuBarAPI: TargetType {
    public var baseURL: URL {
        URLUtil.baseURL
    }

    public var path: String {
        switch self {
        case .login:
            return "/user/login"
        case .refreshToken:
            return "/user/refresh"
        case .fetchSchoolMeal:
            return "/meal/date"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .refreshToken:
            return .put
        case .fetchSchoolMeal:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .login(let accountID, let password):
            return .requestJSONEncodable(LoginRequest(accountID: accountID, password: password))
        case .refreshToken:
            return .requestPlain
        case .fetchSchoolMeal(let date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .login:
            return ["Content-Type": "application/json"]
        case .refreshToken:
            return JwtStore.shared.toHeader(.refreshToken)
        case .fetchSchoolMeal:
            return JwtStore.shared.toHeader(.accessToken)
        }
    }
}

public struct LoginRequest: Encodable {
    let accountID: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case password
    }
}

public struct TokenResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
