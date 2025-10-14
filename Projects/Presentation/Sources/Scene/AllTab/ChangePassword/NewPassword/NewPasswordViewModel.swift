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
        let newPasswordCheckText: Observable<String>
        let accountIdText: Observable<String>
        let codeText: Observable<String>
    }

    public struct Output {
        let isNextButtonEnabled: Observable<Bool>
        let errorToastMessage: Observable<String>
    }

    public func transform(input: Input) -> Output {
        let errorToastRelay = PublishRelay<String>()

        let isFormValid = Observable.combineLatest(
            input.newPasswordText,
            input.newPasswordCheckText
        ) { newPassword, newPasswordCheck in
            return !newPassword.isEmpty && !newPasswordCheck.isEmpty && newPassword == newPasswordCheck
        }
        .distinctUntilChanged()

        input.nextButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.newPasswordText,
                input.accountIdText,
                input.codeText
            ))
            .flatMapLatest { [weak self] password, accountId, code -> Observable<Step> in
                guard let self = self else { return .empty() }
                let params = PasswordChangeRequestParams(
                    password: password,
                    accountId: accountId,
                    code: code
                )
                return self.passwordChangeUseCase.execute(req: params)
                    .andThen(Observable.just(PiCKStep.signinIsRequired))
                    .catch { error in
                        errorToastRelay.accept(error.localizedDescription)
                        return .empty()
                    }
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isFormValid,
            errorToastMessage: errorToastRelay.asObservable()
        )
    }
}
