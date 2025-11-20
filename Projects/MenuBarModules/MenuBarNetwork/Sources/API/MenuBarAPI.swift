import Foundation
import Moya

public enum MenuBarAPI {
    case fetchSchoolMeal(date: String)
}

extension MenuBarAPI: TargetType {
    public var baseURL: URL {
        URL(
            string: Bundle.main.object(
                forInfoDictionaryKey: "API_BASE_URL"
            ) as? String ?? ""
        ) ?? URL(string: "")!
    }

    public var path: String {
        switch self {
        case .fetchSchoolMeal:
            return "/meal/date"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case .fetchSchoolMeal(let date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
