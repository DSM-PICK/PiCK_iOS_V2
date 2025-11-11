import Core
import Foundation
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
        let showPasswordMismatchToast: Observable<Void>
        let showErrorToast: Observable<String>
    }

    public func transform(input: Input) -> Output {
        let errorToastRelay = PublishRelay<String>()

        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&()])[A-Za-z\\d!@#$%^&()]{8,30}$"

        let bothFieldsFilled = Observable.combineLatest(
            input.passwordText,
            input.confirmPasswordText
        ) { password, confirmPassword in
            return !password.isEmpty && !confirmPassword.isEmpty
                }

        let isPasswordMatching = Observable.combineLatest(
            input.passwordText,
            input.confirmPasswordText
        ) { password, confirmPassword in
            return password == confirmPassword
        }

        let isNextButtonEnabled = bothFieldsFilled

        let showPasswordMismatchToast = input.nextButtonTap
            .withLatestFrom(Observable.combineLatest(
                bothFieldsFilled,
                isPasswordMatching
            ))
            .filter { bothFilled, isMatching in
                return bothFilled && !isMatching
            }
            .map { _, _ in () }

        input.nextButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.passwordText,
                bothFieldsFilled,
                isPasswordMatching
            ))
            .filter { _, bothFilled, isMatching in
                return bothFilled && isMatching
            }
            .map { password, _, _ in
                let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
                guard passwordTest.evaluate(with: password) else {
                    errorToastRelay.accept("8~30자 영문자, 숫자, 특수문자 포함하세요")
                    return Observable<Step>.empty()
                }
                return Observable.just(
                    PiCKStep.infoSettingIsRequired(
                        email: input.email,
                        password: password,
                        verificationCode: input.verificationCode
                    )
                )
            }
            .flatMapLatest { $0 }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isNextButtonEnabled,
            showPasswordMismatchToast: showPasswordMismatchToast,
            showErrorToast: errorToastRelay.asObservable()
        )
    }
}
