import Foundation

import Moya

import Core

public enum WeekendMealAPI {
    case weekendMealApply(status: WeekendMealType.RawValue)
    case weekendMealCheck
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
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .weekendMealApply:
                return .patch
            case .weekendMealCheck:
                return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case .weekendMealApply(let status):
                return .requestParameters(
                    parameters: ["status": status],
                    encoding: URLEncoding.queryString
                )
            case .weekendMealCheck:
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

