import Foundation

import Moya

import Core

public protocol PiCKAPI: TargetType {
    associatedtype ErrorType: Error
    var urlType: PiCKURL { get }
    var urlPath: String { get }
    var pickHeader: tokenType { get }
    var errorMap: [Int: ErrorType]? { get }
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
            return TokenStorage.shared.toHeader(.accessToken)
        case .refreshToken:
            return TokenStorage.shared.toHeader(.refreshToken)
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
    case accessToken
    case refreshToken
    case tokenIsEmpty
    
    var toHeader: [String : String] {
//        let keychain = KeychainImpl()
        switch self {
        case .accessToken:
            return TokenStorage.shared.toHeader(.accessToken)
//            return [
//                "content-type": "application/json",
//                "Authorization": TokenStorage.shared.accessToken
//            ]
        case .refreshToken:
            return TokenStorage.shared.toHeader(.refreshToken)
//            return [
//                "content-type": "application/json",
//                "X-Refresh-Token": TokenStorage.shared.refreshToken.
//            ]
        case .tokenIsEmpty:
            return ["Content-Type": "application/json"]
        }
    }
    
}
