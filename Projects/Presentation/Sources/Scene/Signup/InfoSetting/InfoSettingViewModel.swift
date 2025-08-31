import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public final class InfoSettingViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let signUpUseCase: SignUpUseCase

    public init(
        signUpUseCase: SignUpUseCase
    ) {
        self.signUpUseCase = signUpUseCase
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
        let signUpResult: Signal<Bool>
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

        let signUpResult = PublishSubject<Bool>()
        let errorMessage = PublishSubject<String>()

        input.nextButtonDidTap
            .withLatestFrom(info)
            .flatMapLatest { [weak self] grade, classNum, number, name -> Observable<Void> in
                guard let self = self else { return .empty() }
                
                // Int로 변환
                guard let gradeInt = Int(grade),
                      let classNumInt = Int(classNum),
                      let numberInt = Int(number) else {
                    errorMessage.onNext("학번 정보가 올바르지 않습니다.")
                    return .empty()
                }
                
                // 이제 input에서 받은 실제 값들을 사용
                let signUpParams = SignUpRequestParams(
                    accountID: input.email,  // 빈 문자열이 아닌 실제 이메일 사용
                    password: input.password, // 빈 문자열이 아닌 실제 패스워드 사용
                    name: name,
                    grade: gradeInt,
                    classNum: classNumInt,
                    num: numberInt,
                    code: input.verificationCode // 빈 문자열이 아닌 실제 인증코드 사용
                )
                
                print("회원가입 요청 파라미터: \(signUpParams)")
                
                return self.signUpUseCase.execute(req: signUpParams)
                    .andThen(Observable.just(()))
                    .do(onNext: { _ in
                        signUpResult.onNext(true)
                        self.steps.accept(PiCKStep.signUpComplete)
                    })
                    .catch { error in
                        print("회원가입 에러: \(error)")
                        errorMessage.onNext("회원가입에 실패했습니다. 다시 시도해주세요.")
                        signUpResult.onNext(false)
                        return Observable.just(())
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isNextButtonEnabled.asSignal(onErrorJustReturn: false),
            signUpResult: signUpResult.asSignal(onErrorJustReturn: false),
            errorMessage: errorMessage.asSignal(onErrorJustReturn: "")
        )
    }
}
