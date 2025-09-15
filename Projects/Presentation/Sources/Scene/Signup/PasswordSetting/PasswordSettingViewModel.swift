import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public final class PasswordSettingViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init() {}

    public struct Input {
        let email: String
        let verificationCode: String
        let nextButtonTap: Observable<Void>
        let passwordText: Observable<String>
        let confirmPasswordText: Observable<String>
    }

    public struct Output {
        let isNextButtonEnabled: Observable<Bool>
    }

    public func transform(input: Input) -> Output {
        let isPasswordValid = Observable.combineLatest(
            input.passwordText,
            input.confirmPasswordText
        ) { password, confirmPassword in
            return !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword
        }

        input.nextButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.passwordText,
                isPasswordValid
            ))
            .filter { _, isValid in isValid }
            .map { password, _ in
                PiCKStep.infoSettingIsRequired(
                    email: input.email,
                    password: password,
                    verificationCode: input.verificationCode
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isPasswordValid
        )
    }
}
