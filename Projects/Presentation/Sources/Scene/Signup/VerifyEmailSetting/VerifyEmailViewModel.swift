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
    private let verificationButtonTextRelay = BehaviorRelay<String>(value: "인증코드")

    public init(verifyEmailCodeUseCase: VerifyEmailCodeUseCase) {
        self.verifyEmailCodeUseCase = verifyEmailCodeUseCase
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
            .withLatestFrom(isFormValid)
            .filter { $0 }
            .map { _ in PiCKStep.passwordSettingIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isFormValid,
            verificationButtonText: verificationButtonTextRelay.asObservable()
        )
    }
}
