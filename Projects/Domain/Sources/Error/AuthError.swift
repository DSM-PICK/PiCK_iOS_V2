import Foundation

public enum AuthError: Error {
    case idMismatch
    case passwordMismatch
    case serverError
    case deploymentPipelineError
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .idMismatch:
            return "올바른 아이디를 입력해주세요"
        case .passwordMismatch:
            return "올바른 비밀번호를 입력해주세요"
        case .serverError:
            return "PiCK 서버에 오류가 발생했습니다"
        case .deploymentPipelineError:
            return "배포 파이프라인 실행 중 오류가 발생했습니다"
        }
    }
}
