import Foundation

public enum OutingType: String, Codable {
    case application = "APPLICATION"
    case earlyReturn = "EARLY_RETURN"
    case classroom = "CLASSROOM"
}

extension OutingType {
    public var toExplainText: String {
        switch self {
        case .application:
            return "외출 수락 대기 중입니다"
        case .earlyReturn:
            return "조기귀가 수락 대기 중입니다"
        case .classroom:
            return "교실 이동 수락 대기 중입니다"
        }
    }

    public var toPassText: String {
        switch self {
        case .application, .earlyReturn:
            return "외출증 보기"
        case .classroom:
            return "돌아가기"
        }
    }
}
