import Foundation

import Moya

import Core

public enum ClassroomAPI {
    case classroomMoveApply(floor: Int, classroom: String, startPeriod: Int, endPeriod: Int)
    case classroomReturn
}

extension ClassroomAPI: PiCKAPI {
    public typealias ErrorType = PiCKError
    
    public var urlType: PiCKURL {
        return .classRoom
    }
    
    public var urlPath: String {
        switch self {
            case .classroomMoveApply:
                return "/move"
            case .classroomReturn:
                return "/return"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .classroomMoveApply:
                return .post
            case .classroomReturn:
                return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case let .classroomMoveApply(floor, classroom, startPeriod, endPeriod):
                return .requestParameters(
                    parameters: [
                        "floor": floor,
                        "classroom_name": classroom,
                        "start_period": startPeriod,
                        "end_period": endPeriod
                    ],
                    encoding: JSONEncoding.default
                )
            default:
                return .requestPlain
        }
    }
    
    public var pickHeader: tokenType {
        switch self {
        default:
            return .accessToken
        }
    }

    public var errorMap: [Int : PiCKError]? {
        return nil
    }

}

