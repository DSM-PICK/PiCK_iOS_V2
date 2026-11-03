import Foundation

// 새 이벤트는 여기에 case 를 추가하고 name / parameters 만 채우면 됨
// 개인정보(아이디, 사유 등 사용자가 입력한 값)는 파라미터로 보내지 않음
public enum AnalyticsEvent {
    case login
    case applySubmit(type: ApplyType, result: ResultType)
    case passView(type: PassType)
    case noticeOpen
    case bugReportSubmit(result: ResultType)
}

public extension AnalyticsEvent {
    enum ApplyType: String {
        case outing = "outing"
        case earlyLeave = "early_leave"
        case classroomMove = "classroom_move"
        case weekendMeal = "weekend_meal"
    }

    enum PassType: String {
        case outing = "outing"
        case earlyLeave = "early_leave"
    }

    enum ResultType: String {
        case success = "success"
        case fail = "fail"
    }
}

extension AnalyticsEvent {
    var name: String {
        switch self {
        case .login:
            return "login"
        case .applySubmit:
            return "apply_submit"
        case .passView:
            return "pass_view"
        case .noticeOpen:
            return "notice_open"
        case .bugReportSubmit:
            return "bug_report_submit"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .login:
            return ["method": "id_password"]
        case let .applySubmit(type, result):
            return ["apply_type": type.rawValue, "result": result.rawValue]
        case let .passView(type):
            return ["pass_type": type.rawValue]
        case .noticeOpen:
            return nil
        case let .bugReportSubmit(result):
            return ["result": result.rawValue]
        }
    }
}
