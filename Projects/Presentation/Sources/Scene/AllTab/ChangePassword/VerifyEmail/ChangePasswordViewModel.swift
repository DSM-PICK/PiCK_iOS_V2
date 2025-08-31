import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public class ChangePasswordViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init() {}

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
            .subscribe(onNext: { [weak self] email, certification in
                print("다음 버튼 탭됨 - 이메일: \(email), 인증코드: \(certification)")
                self?.handleNextButtonTap(email: email, certification: certification)
            })
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isFormValid
        )
    }

    private func handleNextButtonTap(email: String, certification: String) {
        print("이메일 인증 처리 완료 - newPasswordIsRequired Step 발생")
        steps.accept(PiCKStep.newPasswordIsRequired)
    }
}
