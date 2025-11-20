import Core
import Foundation
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public class ChangePasswordViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    // 🔥 수정: 타이머 시작 신호를 네트워크 성공과 분리
    private let startTimerRelay = PublishRelay<Void>()
    private let verificationSuccessRelay = PublishRelay<Void>()

    private let verifyEmailCodeUseCase: VerifyEmailCodeUseCase
    private let mailCodeCheckUseCase: MailCodeCheckUseCase

    init(
        verifyEmailCodeUseCase: VerifyEmailCodeUseCase,
        mailCodeCheckUseCase: MailCodeCheckUseCase
    ) {
        self.verifyEmailCodeUseCase = verifyEmailCodeUseCase
        self.mailCodeCheckUseCase = mailCodeCheckUseCase
    }

    public struct Input {
        let nextButtonTap: Observable<Void>
        let verificationButtonTap: Observable<Void>
        let emailText: Observable<String>
        let certificationText: Observable<String>
    }

    public struct Output {
        let isNextButtonEnabled: Observable<Bool>
        let showErrorToast: Observable<String>
        let startTimer: Observable<Void>  // 🔥 추가: 타이머 시작 신호
    }

    public func transform(input: Input) -> Output {
        let errorToastRelay = PublishRelay<String>()

        let isFormValid = Observable.combineLatest(
            input.emailText,
            input.certificationText
        ) { email, certification in
            return !email.isEmpty && !certification.isEmpty
        }
        .distinctUntilChanged()

        // 🔥 수정: 버튼 탭 시 즉시 타이머 시작 신호 발생
        input.verificationButtonTap
            .withLatestFrom(input.emailText)
            .filter { !$0.isEmpty }  // 이메일이 비어있지 않을 때만
            .do(onNext: { [weak self] _ in
                self?.startTimerRelay.accept(())  // 즉시 타이머 시작 신호
            })
            .flatMapLatest { [weak self] email -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.sendVerificationCode(email: email, errorRelay: errorToastRelay)
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.nextButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.emailText,
                input.certificationText
            ))
            .flatMapLatest { [weak self] email, certification -> Observable<(String, String)> in
                guard let self = self else { return .empty() }
                return self.verifyCode(email: email, code: certification, errorRelay: errorToastRelay)
                    .map { _ in (email, certification) }
            }
            .subscribe(onNext: { [weak self] email, certification in
                self?.steps.accept(PiCKStep.newPasswordIsRequired(accountId: email, code: certification))
            })
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isFormValid,
            showErrorToast: errorToastRelay.asObservable(),
            startTimer: startTimerRelay.asObservable()  // 🔥 추가
        )
    }

    private func sendVerificationCode(email: String, errorRelay: PublishRelay<String>) -> Observable<Void> {
        guard !email.isEmpty else {
            errorRelay.accept("이메일을 입력해주세요")
            return .empty()
        }

        return self.verifyEmailCodeUseCase.execute(
            req: VerifyEmailCodeRequestParams(
                mail: email,
                message: "비밀번호 변경 인증",
                title: "비밀번호 변경 인증"
            )
        )
        .asObservable()
        .map { _ in }
        .catch { error in
            if let nsError = error as NSError? {
                if let message = nsError.userInfo[NSLocalizedDescriptionKey] as? String, !message.isEmpty {
                    errorRelay.accept(message)
                    return .empty()
                }
                if let message = nsError.userInfo["message"] as? String, !message.isEmpty {
                    errorRelay.accept(message)
                    return .empty()
                }
            }
            errorRelay.accept(error.localizedDescription)
            return .empty()
        }
    }

    private func verifyCode(email: String, code: String, errorRelay: PublishRelay<String>) -> Observable<String> {
        return self.mailCodeCheckUseCase.execute(
            req: MailCodeCheckRequestParams(
                email: email,
                code: code
            )
        )
        .asObservable()
        .flatMap { acountIdOrValid -> Observable<String> in
            if let isValid = acountIdOrValid as? Bool {
                if isValid {
                    return .just(email)
                } else {
                    errorRelay.accept("인증코드가 올바르지 않습니다")
                    return .empty()
                }
            } else if let acountId = acountIdOrValid as? String {
                return .just(acountId)
            } else {
                errorRelay.accept("인증코드 확인 중 오류가 발생했습니다")
                return .empty()
            }
        }
        .catch { error in
            if let nsError = error as NSError? {
                if let message = nsError.userInfo[NSLocalizedDescriptionKey] as? String, !message.isEmpty {
                    errorRelay.accept(message)
                    return .empty()
                }
                if let message = nsError.userInfo["message"] as? String, !message.isEmpty {
                    errorRelay.accept(message)
                    return .empty()
                }
            }
            errorRelay.accept(error.localizedDescription)
            return .empty()
        }
    }
}
