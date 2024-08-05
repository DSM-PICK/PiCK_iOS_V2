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
        let clickWeekendMealButton: Observable<Void>
        let clickClassRoomMoveButton: Observable<Void>
        let clickOutingButton: Observable<Void>
        let clickEarlyLeaveButton: Observable<Void>
    }
    public struct Output {}
    
    public func transform(input: Input) -> Output {
        input.clickOutingButton
            .map { PiCKStep.outingApplyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickEarlyLeaveButton
            .map { PiCKStep.earlyLeaveApplyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
    
}
