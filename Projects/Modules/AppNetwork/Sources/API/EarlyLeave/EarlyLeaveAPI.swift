import Foundation

import Moya

import Core

public enum EarlyLeaveAPI {
    case earlyLeaveApply(reason: String, startTime: String)
    case fetchEarlyLeavePass
}

extension EarlyLeaveAPI: PiCKAPI {
    public typealias ErrorType = PiCKError
    
    public var urlType: PiCKURL {
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
            case let .earlyLeaveApply(reason, startTime):
                return .requestParameters(
                    parameters: [
                        "reason": reason,
                        "start_time": startTime
                    ],
                    encoding: JSONEncoding.default
                )
            case .fetchEarlyLeavePass:
                return .requestPlain
        }
    }
    
    public var pickHeader: tokenType {
        return .accessToken
    }

    public var errorMap: [Int : PiCKError]? {
        return nil
    }

}
