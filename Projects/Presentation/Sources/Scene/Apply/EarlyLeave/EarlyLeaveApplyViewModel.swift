import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class EarlyLeaveApplyViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {
        let startTime: Observable<String>
        let clickStartTimeButton: Observable<Void>
        let reasonText: Observable<String>
        let clickApplyButton: Observable<Void>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }

    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.reasonText,
            input.startTime
        )
        
        let isApplyButtonEnable = info.map { reason, startTime -> Bool in !reason.isEmpty && !startTime.isEmpty
        }
        
        input.clickStartTimeButton.asObservable()
            .map { PiCKStep.timeSelectAlertIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output(isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false))
    }
    
}
