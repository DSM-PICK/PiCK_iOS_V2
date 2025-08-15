import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum MailAPI {
    case verifyEmailCode(req: VerifyEmailCodeRequestParams)
    case mailCodeCheck(req: MailCodeCheckRequestParams)
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
        case .mailCodeCheck:
            return "/check"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .verifyEmailCode, .mailCodeCheck:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .verifyEmailCode(req):
            return .requestJSONEncodable(req)
        case let .mailCodeCheck(req):
            return .requestJSONEncodable(req)
        }
    }

    public var pickHeader: TokenType {
        return .tokenIsEmpty
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
