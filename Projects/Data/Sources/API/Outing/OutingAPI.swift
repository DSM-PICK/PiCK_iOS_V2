import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum OutingAPI {
    case outingApply(req: OutingApplyRequestParams)
    case fetchOutingPass
}

extension OutingAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var urlType: PiCKURL {
        return .application
    }

    public var urlPath: String {
        switch self {
        case .outingApply:
            return ""
        case .fetchOutingPass:
            return "/my"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .outingApply:
            return .post
        default:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .outingApply(req):
            return .requestParameters(
                parameters: [
                    "reason": req.reason,
                    "start": req.startTime,
                    "end": req.endTime,
                    "application_type": req.applicationType
                ],
                encoding: JSONEncoding.default
            )
        default:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        return .accessToken
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
