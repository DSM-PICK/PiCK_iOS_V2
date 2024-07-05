import Foundation

import Moya

import Core

public enum OutingAPI {
    case outingApply(reason: String, startTime: String, endTime: String)
    case fetchOutingPass
}

extension OutingAPI: PiCKAPI {
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
        case let .outingApply(reason, startTime, endTime):
            return .requestParameters(
                parameters: [
                    "reason": reason,
                    "start_time": startTime,
                    "end_time": endTime
                ],
                encoding: JSONEncoding.default
            )
        default:
            return .requestPlain
        }
    }
    
    public var pickHeader: tokenType {
        return .accessToken
    }
    
    
}
