import Foundation

import Moya

import Core

public protocol PiCKAPI: TargetType {
    var urlType: PiCKURL { get }
    var urlPath: String { get }
    var pickHeader: tokenType { get }
}

public extension PiCKAPI {
    var baseURL: URL {
        URLUtil.baseURL
    }
    
    var path: String {
        urlType.asURLString + urlPath
    }

    var headers: [String : String]? {
        switch pickHeader {
        case .accessToken:
            return tokenType.accessToken.toHeader
        case .refreshToken:
            return tokenType.refreshToken.toHeader
        case .tokenIsEmpty:
            return ["Content-Type": "application/json"]
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

public enum PiCKURL: String {
    case user
    case main
    case selfStudy = "self-study"
    case earlyReturn = "early-return"
    case classRoom = "class-room"
    case application
    case weekendMeal = "weekend-meal"
    case notice
    case meal
    case timeTable = "timetable"
    case schedule
    
    var asURLString: String {
        "/\(self.rawValue)"
    }
}

public enum tokenType: String {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case tokenIsEmpty
    
    var toHeader: [String : String] {
        switch self {
        case .accessToken:
            return [
                "content-type": "application/json",
                "Authorization": KeychainType.accessToken.rawValue
            ]
        case .refreshToken:
            return [
                "content-type": "application/json",
                "Authorization": KeychainType.refreshToken.rawValue
            ]
        case .tokenIsEmpty:
            return ["Content-Type": "application/json"]
        }
    }
    
}
