import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum HomeAPI {
    case fetchHomeApplyStatus
}

extension HomeAPI: PiCKAPI {
    public typealias ErrorType = PiCKError
    
    public var urlType: PiCKURL {
        return .main
    }
    
    public var urlPath: String {
        switch self {
            case .fetchHomeApplyStatus:
                return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchHomeApplyStatus:
                return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case .fetchHomeApplyStatus:
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
