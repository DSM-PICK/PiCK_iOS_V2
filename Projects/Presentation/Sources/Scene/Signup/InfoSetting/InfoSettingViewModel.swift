import Core
import DesignSystem
import RxFlow
import RxSwift
import RxCocoa
import Domain

public final class InfoSettingViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    // UseCase 추가 (필요시)
    // private let userInfoUseCase: UserInfoUseCase

    public init(
        // userInfoUseCase: UserInfoUseCase
    ) {
        // self.userInfoUseCase = userInfoUseCase
    }

    public struct Input {
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

        input.nextButtonDidTap
            .withLatestFrom(info)
            .bind { grade, classNum, number, name in
                // 학번 정보 저장 로직
                print("학번 정보 저장: \(grade)학년 \(classNum)반 \(number)번, 이름: \(name)")

                // 다음 스텝으로 이동하거나 처리 완료 알림
                // self.steps.accept(PiCKStep.nextStep)
            }
            .disposed(by: disposeBag)

        return Output(
            isNextButtonEnabled: isNextButtonEnabled.asSignal(onErrorJustReturn: false)
        )
    }
}
