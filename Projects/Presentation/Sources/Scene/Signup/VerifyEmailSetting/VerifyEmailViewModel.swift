import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public class VerifyEmailViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    private let verifyEmailCodeUseCase: VerifyEmailCodeUseCase
    private let mailCodeCheckUseCase: MailCodeCheckUseCase
    private let verificationButtonTextRelay = BehaviorRelay<String>(value: "인증코드")

    public init(
        verifyEmailCodeUseCase: VerifyEmailCodeUseCase,
        mailCodeCheckUseCase: MailCodeCheckUseCase
    ) {
        self.verifyEmailCodeUseCase = verifyEmailCodeUseCase
        self.mailCodeCheckUseCase = mailCodeCheckUseCase
    }

    public struct Input {
        let nextButtonTap: Observable<Void>
        let emailText: Observable<String>
        let certificationText: Observable<String>
        let verificationButtonTap: Observable<Void>
    }

    public struct Output {
        let isNextButtonEnabled: Observable<Bool>
        let verificationButtonText: Observable<String>
    }

    public func transform(input: Input) -> Output {
        let isFormValid = Observable.combineLatest(
            input.emailText,
            input.certificationText
        ) { email, certification in
            return !email.isEmpty && !certification.isEmpty
        }

        input.verificationButtonTap
            .withLatestFrom(input.emailText)
            .filter { !$0.isEmpty }
            .flatMap { [weak self] email in
                return self?.verifyEmailCodeUseCase.execute(
                    req: VerifyEmailCodeRequestParams(
                        mail: "\(email)",
                        message: "아래 인증번호를 진행 인증 화면에 입력해주세요",
                        title: "회원가입 제목 테스트"
                    )
                )
                .do(onCompleted: {
                    self?.verificationButtonTextRelay.accept("재발송")
                })
                .catch { error in
                    return .never()
                } ?? .never()
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.nextButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.emailText,
                input.certificationText,
                isFormValid
            ))
            .filter { _, _, isValid in isValid }
            .flatMap { [weak self] email, code, _ -> Observable<Void> in
                guard let self = self else { return .empty() }

                return self.mailCodeCheckUseCase.execute(
                    req: MailCodeCheckRequestParams(
                        mail: email,
                        code: code
                    )
                )
                .andThen(Observable.just(()))
                .catch { error in
                    return .empty()
                }
            }
            .map { _ in PiCKStep.passwordSettingIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isFormValid,
            verificationButtonText: verificationButtonTextRelay.asObservable()
        )
    }
}
