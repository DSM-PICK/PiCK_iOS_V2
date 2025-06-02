import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ApplyViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    public init() {}

    public struct Input {
        let weekendMealApplyButtonDidTap: Observable<Void>
        let classroomMoveApplyButtonDidTap: Observable<Void>
        let outingApplyButtonDidTap: Observable<Void>
        let earlyLeaveApplyButtonDidTap: Observable<Void>
    }
    public struct Output {}

    public func transform(input: Input) -> Output {
        input.weekendMealApplyButtonDidTap
            .map { PiCKStep.weekendMealApplyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.classroomMoveApplyButtonDidTap
            .map { PiCKStep.classroomMoveApplyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.outingApplyButtonDidTap
            .map { PiCKStep.outingApplyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.earlyLeaveApplyButtonDidTap
            .map { PiCKStep.earlyLeaveApplyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }

}
