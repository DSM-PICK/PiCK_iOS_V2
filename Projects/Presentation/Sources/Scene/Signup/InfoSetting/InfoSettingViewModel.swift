import Core
import FirebaseMessaging
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public final class InfoSettingViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let signupUseCase: SignupUseCase
    private let signinUseCase: SigninUseCase

    public init(
        signupUseCase: SignupUseCase,
        signinUseCase: SigninUseCase
    ) {
        self.signupUseCase = signupUseCase
        self.signinUseCase = signinUseCase
    }

    public struct Input {
        let email: String
        let password: String
        let verificationCode: String
        let grade: Observable<String>
        let selectGradeButtonDidTap: Observable<Void>
        let classNumber: Observable<String>
        let selectClassButtonDidTap: Observable<Void>
        let number: Observable<String>
        let selectNumberButtonDidTap: Observable<Void>
        let name: Observable<String>
        let nextButtonDidTap: Observable<Void>
    }

    public struct Output {
        let isNextButtonEnabled: Signal<Bool>
        let signupResult: Signal<Bool>
        let errorMessage: Signal<String>
    }

    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.grade,
            input.classNumber,
            input.number,
            input.name
        )

        let isNextButtonEnabled = info.map { grade, classNum, number, name -> Bool in
            return !grade.isEmpty && !classNum.isEmpty && !number.isEmpty && !name.isEmpty
        }

        let signupResult = PublishSubject<Bool>()
        let errorMessage = PublishSubject<String>()

        input.nextButtonDidTap
            .withLatestFrom(info)
            .flatMapLatest { [weak self] grade, classNum, number, name -> Observable<Void> in
                guard let self = self else { return .empty() }

                guard let gradeInt = Int(grade),
                      let classNumInt = Int(classNum),
                      let numberInt = Int(number) else {
                    errorMessage.onNext("학번 정보가 올바르지 않습니다.")
                    return .empty()
                }

                let signupParams = SignupRequestParams(
                    accountID: input.email,
                    password: input.password,
                    name: name,
                    grade: gradeInt,
                    classNum: classNumInt,
                    num: numberInt,
                    code: input.verificationCode
                )

                return self.signupUseCase.execute(req: signupParams)
                    .andThen(
                        self.signinUseCase.execute(
                            req: SigninRequestParams(
                                accountID: input.email,
                                password: input.password,
                                deviceToken: Messaging.messaging().fcmToken ?? ""
                            )
                        )
                    )
                    .andThen(Observable.just(()))
                    .do(onNext: { _ in
                        signupResult.onNext(true)
                        self.steps.accept(PiCKStep.signupComplete)
                    })
                    .catch { _ in
                        errorMessage.onNext("회원가입 또는 로그인에 실패했습니다. 다시 시도해주세요.")
                        signupResult.onNext(false)
                        return Observable.just(())
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isNextButtonEnabled.asSignal(onErrorJustReturn: false),
            signupResult: signupResult.asSignal(onErrorJustReturn: false),
            errorMessage: errorMessage.asSignal(onErrorJustReturn: "")
        )
    }
}
