import Foundation

import Moya

import Core

public enum AuthAPI {
    case login(accountID: String, password: String)
    case refreshToken(refreshToken: String)
}

extension AuthAPI: PiCKAPI {
    
    public var urlType: PiCKURL {
        .user
    }
    
    public var urlPath: String {
        switch self {
            case .login:
                return "/login"
            case .refreshToken:
                return "/refresh"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .login:
                return .post
            case .refreshToken:
                return .put
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case let .login(accountID, password):
                return .requestParameters(
                    parameters: [
                        "account_id": accountID,
                        "password": password
                    ],
                    encoding: JSONEncoding.default
                )
                
            case .refreshToken(let refreshToken):
                return .requestParameters(
                    parameters: ["X-Refresh-Token": refreshToken],
                    encoding: JSONEncoding.default
                )
        }
    }
    
    public var pickHeader: tokenType {
        switch self {
        case .refreshToken:
            return .accessToken
        default:
            return .tokenIsEmpty
        }
    }
//    public var headers: [String : String]? {
//        switch self {
//            case .login:
//            return
////                return TokenStorage.shared.toHeader(.tokenIsEmpty)
//            case .refreshToken:
//                return TokenStorage.shared.toHeader(.refreshToken)
//        }
//    }
    
    
}
