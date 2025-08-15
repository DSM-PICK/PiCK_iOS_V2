import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum MailAPI {
    case verifyEmailCode(req: VerifyEmailCodeRequestParams)
}

extension MailAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: PiCKDomain {
        return .mail
    }

    public var urlPath: String {
        switch self {
        case .verifyEmailCode:
            return "/send"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .verifyEmailCode:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .verifyEmailCode(req):
            return .requestJSONEncodable(req)
        default:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        return .tokenIsEmpty
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
