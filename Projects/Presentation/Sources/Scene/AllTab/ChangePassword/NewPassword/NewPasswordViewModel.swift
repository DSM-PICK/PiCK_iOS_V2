import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public class NewPasswordViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let passwordChangeUseCase: PasswordChangeUseCase

    public init(
        passwordChangeUseCase: PasswordChangeUseCase
    ) {
        self.passwordChangeUseCase = passwordChangeUseCase
    }

    public struct Input {
        let nextButtonTap: Observable<Void>
        let newPasswordText: Observable<String>
        let certificationText: Observable<String>
    }

    public struct Output {
        let isNextButtonEnabled: Observable<Bool>
    }

    public func transform(input: Input) -> Output {
        let isFormValid = Observable.combineLatest(
            input.newPasswordText,
            input.certificationText
        ) { password, certification in
            return !password.isEmpty && !certification.isEmpty
        }
        .distinctUntilChanged()

        input.nextButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.newPasswordText,
                input.certificationText
            ))
            .flatMapLatest { [weak self] password, certification -> Observable<Step> in
                guard let self = self else { return Observable<Step>.empty() }
                let params = PasswordChangeRequestParams(
                    password: password,
                    code: certification
                )
                return self.passwordChangeUseCase.execute(req: params)
                    .andThen(Observable.just(PiCKStep.signinIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isFormValid
        )
    }
}
