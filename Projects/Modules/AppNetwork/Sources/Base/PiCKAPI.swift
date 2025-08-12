import Foundation

import Moya

import Core

public protocol PiCKAPI: TargetType {
    associatedtype ErrorType: Error
    var domain: PiCKDomain { get }
    var urlPath: String { get }
    var pickHeader: TokenType { get }
    var errorMap: [Int: ErrorType]? { get }
}

public extension PiCKAPI {
    var baseURL: URL {
        URLUtil.baseURL
    }

    var path: String {
        domain.asURLString + urlPath
    }

    var headers: [String: String]? {
        switch pickHeader {
        case .accessToken:
            return JwtStore.shared.toHeader(.accessToken)
        case .refreshToken:
            return JwtStore.shared.toHeader(.refreshToken)
        case .tokenIsEmpty:
            return ["Content-Type": "application/json"]
        }
    }

    var validationType: ValidationType {
        return .successCodes
    }
}

public enum PiCKDomain: String {
    case user
    case main
    case selfStudy = "self-study"
    case earlyReturn = "early-return"
    case classroom = "class-room"
    case application
    case weekendMeal = "weekend-meal"
    case notice
    case meal
    case timeTable = "timetable"
    case schedule
    case bug
    case notification
    case mail

    var asURLString: String {
        "/\(self.rawValue)"
    }
}

public enum TokenType: String {
    case accessToken
    case refreshToken
    case tokenIsEmpty

    var toHeader: [String: String] {
        switch self {
        case .accessToken:
            return JwtStore.shared.toHeader(.accessToken)
        case .refreshToken:
            return JwtStore.shared.toHeader(.refreshToken)
        case .tokenIsEmpty:
            return ["Content-Type": "application/json"]
        }
    }

}
