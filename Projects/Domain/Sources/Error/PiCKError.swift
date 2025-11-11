import Foundation

public enum PiCKError: Error {
    case error(message: String = "에러가 발생했습니다.", errorBody: [String: Any] = [:])
    case deploymentPipelineError
    case serverError
}

extension PiCKError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .error(message, _):
            return message
        case .deploymentPipelineError:
            return "배포 파이프라인 실행 중 오류가 발생했습니다"
        case .serverError:
            return "PiCK 서버에 오류가 발생했습니다"
        }
    }
}
