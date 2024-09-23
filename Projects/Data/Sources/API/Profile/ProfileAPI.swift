import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum ProfileAPI {
    case fetchSimpleProfile
    case fetchDetailProfile
}

extension ProfileAPI: PiCKAPI {
    public typealias ErrorType = PiCKError
    
    public var urlType: PiCKURL {
        return .user
    }
    
    public var urlPath: String {
        switch self {
            case .fetchSimpleProfile:
                return "/simple"
            case .fetchDetailProfile:
                return "/details"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        return .requestPlain
    }
    
    public var pickHeader: TokenType {
        return .accessToken
    }

    public var errorMap: [Int : PiCKError]? {
        return nil
    }

}
