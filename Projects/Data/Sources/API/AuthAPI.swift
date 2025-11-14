import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum AuthAPI {
    case signin(req: SigninRequestParams)
    case refreshToken
    case signup(req: SignupRequestParams)
    case passwordChange(req: PasswordChangeRequestParams)
    case resign
}

extension AuthAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: PiCKDomain {
        return .user
    }

    public var urlPath: String {
        switch self {
        case .signin:
            return "/login"
        case .signup:
            return "/signup"
        case .refreshToken:
            return "/refresh"
        case .passwordChange:
            return "/password"
        case .resign:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .signin, .signup, .passwordChange:
            return .post
        case .refreshToken:
            return .put
        case .resign:
            return .delete
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .signin(req):
            return .requestJSONEncodable(req)
        case let .signup(req):
            return .requestJSONEncodable(req)
        case let .passwordChange(req):
            return .requestJSONEncodable(req)
        default:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        switch self {
        case .refreshToken:
            return .refreshToken
        case .resign:
            return .accessToken
        default:
            return .tokenIsEmpty
        }
    }

    public var errorMap: [Int: ErrorType]? {
        return [
            500: .serverError,
            503: .deploymentPipelineError
        ]
    }
}
