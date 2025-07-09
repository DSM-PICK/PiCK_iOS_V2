import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public class NewPasswordViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    public init() {

    }

    public struct Input {
        let nextButtonTap: Observable<Void>
        let emailText: Observable<String>
        let certificationText: Observable<String>
    }

    public struct Output {
        let isNextButtonEnabled: Observable<Bool>
    }

    public func transform(input: Input) -> Output {
        let isFormValid = Observable.combineLatest(
            input.emailText,
            input.certificationText
        ) { email, certification in
            return !email.isEmpty && !certification.isEmpty
        }
        .distinctUntilChanged()

        input.nextButtonTap
            .withLatestFrom(Observable.combineLatest(
                input.emailText,
                input.certificationText
            ))
            .do(onNext: { email, certification in
            })
            .map { _ in PiCKStep.logoutIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isFormValid
        )
    }
}
