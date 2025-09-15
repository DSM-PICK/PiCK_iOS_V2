import Foundation
import RxSwift
import RxCocoa
import RxFlow
import ReactorKit
import Core
import Domain

public final class VerifyEmailReactor: BaseReactor {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    public let initialState: State

    private let verifyEmailCodeUseCase: VerifyEmailCodeUseCase
    private let mailCodeCheckUseCase: MailCodeCheckUseCase

    init(
        verifyEmailCodeUseCase: VerifyEmailCodeUseCase,
        mailCodeCheckUseCase: MailCodeCheckUseCase
    ) {
        self.initialState = .init()
        self.verifyEmailCodeUseCase = verifyEmailCodeUseCase
        self.mailCodeCheckUseCase = mailCodeCheckUseCase
    }

    public enum Action {
        case updateEmail(String)
        case updateCertification(String)
        case verificationButtonDidTap
        case nextButtonDidTap
    }

    public enum Mutation {
        case updateEmail(String)
        case updateCertification(String)
        case emailError(String)
        case certificationError(String)
        case errorReset
        case isNextButtonEnabled(Bool)
        case updateVerificationButtonText(String)
        case verificationCodeSent
        case verificationSuccess
        case navigateToPasswordSetting
    }

    public struct State {
        var email: String = ""
        var certification: String = ""
        var emailErrorDescription: String = ""
        var certificationErrorDescription: String = ""
        var isNextButtonEnabled: Bool = false
        var verificationButtonText: String = "인증코드"
    }
}

extension VerifyEmailReactor {
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .updateEmail(let email):
            let enabled = !email.isEmpty && !self.currentState.certification.isEmpty
            return .concat([
                .just(.isNextButtonEnabled(enabled)),
                .just(.updateEmail(email))
            ])
        case .updateCertification(let certification):
            let enabled = !self.currentState.email.isEmpty && !certification.isEmpty
            return .concat([
                .just(.isNextButtonEnabled(enabled)),
                .just(.updateCertification(certification))
            ])
        case .verificationButtonDidTap:
            return sendVerificationCode(email: self.currentState.email)
        case .nextButtonDidTap:
            return .concat([
                verifyCode(
                    email: self.currentState.email,
                    code: self.currentState.certification
                ),
                .just(.errorReset)
            ])
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateEmail(let email):
            newState.email = email
        case .updateCertification(let certification):
            newState.certification = certification
        case .emailError(let error):
            newState.emailErrorDescription = error
        case .certificationError(let error):
            newState.certificationErrorDescription = error
        case .errorReset:
            newState.emailErrorDescription = ""
            newState.certificationErrorDescription = ""
        case .isNextButtonEnabled(let enabled):
            newState.isNextButtonEnabled = enabled
        case .updateVerificationButtonText(let text):
            newState.verificationButtonText = text
        case .verificationCodeSent:
            newState.verificationButtonText = "재발송"
        case .verificationSuccess:
            break
        case .navigateToPasswordSetting:
            steps.accept(PiCKStep.passwordSettingIsRequired(
                email: newState.email,
                verificationCode: newState.certification
            ))
        }
        return newState
    }

    private func sendVerificationCode(email: String) -> Observable<Mutation> {
        guard !email.isEmpty else {
            return .just(.emailError("이메일을 입력해주세요"))
        }

        return self.verifyEmailCodeUseCase.execute(
            req: VerifyEmailCodeRequestParams(
                mail: email,
                message: "아래 인증번호를 진행 인증 화면에 입력해주세요",
                title: "회원가입 제목 테스트"
            )
        )
        .andThen(Observable.just(Mutation.verificationCodeSent))
        .catch { _ in
            return .just(.emailError("이메일 인증코드 발송에 실패했습니다"))
        }
    }

    private func verifyCode(email: String, code: String) -> Observable<Mutation> {
        guard !email.isEmpty else {
            return .just(.emailError("이메일을 입력해주세요"))
        }

        guard !code.isEmpty else {
            return .just(.certificationError("인증코드를 입력해주세요"))
        }

        return self.mailCodeCheckUseCase.execute(
            req: MailCodeCheckRequestParams(
                email: email,
                code: code
            )
        )
        .andThen(Observable.just(Mutation.navigateToPasswordSetting))
        .catch { _ in
            return .just(.certificationError("인증코드가 올바르지 않습니다"))
        }
    }
}
