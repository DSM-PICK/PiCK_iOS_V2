import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public class ChangePasswordViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

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
        let verificationButtonText: Observable<String>
        let errorToastMessage: Observable<String>
    }

    public func transform(input: Input) -> Output {
        let verificationButtonTextRelay = BehaviorRelay<String>(value: "인증코드")
        let errorToastRelay = PublishRelay<String>()

        let isFormValid = Observable.combineLatest(
            input.emailText,
            input.certificationText
        ) { email, certification in
            return !email.isEmpty && !certification.isEmpty
        }
        .distinctUntilChanged()

        input.verificationButtonTap
            .withLatestFrom(input.emailText)
            .flatMapLatest { [weak self] email -> Observable<Void> in
                guard let self = self else { return .empty() }
                return self.sendVerificationCode(email: email, errorRelay: errorToastRelay)
            }
            .subscribe(onNext: {
                verificationButtonTextRelay.accept("재발송")
            })
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
            verificationButtonText: verificationButtonTextRelay.asObservable(),
            errorToastMessage: errorToastRelay.asObservable()
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
                message: "아래 인증번호를 진행 인증 화면에 입력해주세요",
                title: "비밀번호 변경 인증"
            )
        )
        .asObservable()
        .map { _ in }
        .catch { _ in
            errorRelay.accept("이메일 인증코드 발송에 실패했습니다")
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
        .catch { _ in
            errorRelay.accept("인증코드 확인 중 오류가 발생했습니다")
            return .empty()
        }
    }
}
