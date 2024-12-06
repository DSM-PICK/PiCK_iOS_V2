import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum EarlyLeaveAPI {
    case earlyLeaveApply(req: EarlyLeaveApplyRequestParams)
    case fetchEarlyLeavePass
}

extension EarlyLeaveAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: PiCKDomain {
        return .earlyReturn
    }

    public var urlPath: String {
        switch self {
        case .earlyLeaveApply:
            return "/create"
        case .fetchEarlyLeavePass:
            return "/my"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .earlyLeaveApply:
            return .post
        case .fetchEarlyLeavePass:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .earlyLeaveApply(req):
            return .requestJSONEncodable(req)
        case .fetchEarlyLeavePass:
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
