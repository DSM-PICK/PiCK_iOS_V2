import Foundation

import Moya

import Core

public enum MainAPI {
    case fetchMainData
}

extension MainAPI: PiCKAPI {
    public var urlType: PiCKURL {
        return .main
    }
    
    public var urlPath: String {
        switch self {
            case .fetchMainData:
                return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .fetchMainData:
                return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case .fetchMainData:
                return .requestPlain
        }
    }
    
    public var pickHeader: tokenType {
        return .accessToken
    }
    
}
