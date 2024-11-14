import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum WeekendMealAPI {
    case weekendMealApply(status: WeekendMealType.RawValue)
    case weekendMealCheck
    case weekendMealApplication
    case weekendMealPeriod
}

extension WeekendMealAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var urlType: PiCKURL {
        return .weekendMeal
    }

    public var urlPath: String {
        switch self {
        case .weekendMealApply:
            return "/my-status"
        case .weekendMealCheck:
            return "/my"
        case .weekendMealApplication:
            return "/application"
        case .weekendMealPeriod:
            return "/period"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .weekendMealApply:
            return .patch
        default:
            return .get
        }
    }

    public var task: Moya.Task {
        switch self {
        case .weekendMealApply(let status):
            return .requestParameters(
                parameters: [
                    "status": status
                ],
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        return .accessToken
    }

    public var errorMap: [Int: PiCKError]? {
        return nil
    }

}
