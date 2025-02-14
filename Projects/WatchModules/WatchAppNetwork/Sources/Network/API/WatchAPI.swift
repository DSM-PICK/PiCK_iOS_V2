import Foundation

import Moya

public enum WatchAPI {
    case fetchSchoolMeal(date: String)
    case fetchTimeTable
    case fetchSelfStudy(date: String)
}

extension WatchAPI: TargetType {
    public var baseURL: URL {
        URL(
            string: Bundle.main.object(
                forInfoDictionaryKey: "API_BASE_URL"
            ) as? String ?? "") ?? URL(string: "")!
    }

    public var path: String {
        switch self {
        case .fetchSchoolMeal:
            return "/meal/date"
        case .fetchTimeTable:
            return "/timetable/today"
        case .fetchSelfStudy:
            return "/self-study/today"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case .fetchSchoolMeal(let date):
            return .requestParameters(
                parameters: [
                    "date": date
                ],
                encoding: URLEncoding.queryString
            )

        case .fetchTimeTable:
            return .requestPlain

        case .fetchSelfStudy(let date):
            return .requestParameters(
                parameters: [
                    "date": date
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        return JwtStore().toHeader(.accessToken)
    }

}
