import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum AuthAPI {
    case login(req: SigninRequestParams)
    case refreshToken
    case verifyEmailCode(req: VerifyEmailCodeRequestParams)
}

extension AuthAPI: PiCKAPI {
    public typealias ErrorType = AuthError

    public var domain: PiCKDomain {
        return .user
    }

    public var urlPath: String {
        switch self {
        case .login:
            return "/login"
        case .refreshToken:
            return "/refresh"
        case .verifyEmailCode:
            return "/send"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login, .verifyEmailCode:
            return .post
        case .refreshToken:
            return .put
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .login(req):
            return .requestJSONEncodable(req)
        case let .verifyEmailCode(req):
            return .requestJSONEncodable(req)
        default:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        switch self {
        case .refreshToken:
            return .refreshToken
        default:
            return .tokenIsEmpty
        }
    }

    public var errorMap: [Int: ErrorType]? {
        switch self {
        case .login(let req):
            return [
                401: .passwordMismatch,
                404: .idMismatch
            ]
        default:
            return nil
        }
    }

}
