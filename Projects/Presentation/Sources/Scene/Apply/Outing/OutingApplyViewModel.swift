import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class OutingApplyViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let outingApplyUseCase: OutingApplyUseCase

    public init(outingApplyUseCase: OutingApplyUseCase) {
        self.outingApplyUseCase = outingApplyUseCase
    }

    public struct Input {
        let startTime: Observable<String>
        let clickStartTimeButton: Observable<Void>
        let endTime: Observable<String>
        let clickEndTimeButton: Observable<Void>
        let reasonText: Observable<String?>
        let clickOutingApply: Observable<Void>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }

    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.reasonText,
            input.startTime,
            input.endTime
        )
        
        let isApplyButtonEnable = info.map { reason, startTime, endTime -> Bool in 
            !reason!.isEmpty && !startTime.isEmpty && !endTime.isEmpty && startTime < endTime
        }

        input.clickOutingApply.asObservable()
            .withLatestFrom(info)
            .flatMap { reason, startTime, endTime in
                self.outingApplyUseCase.execute(req: .init(
                    reason: reason ?? "",
                    startTime: startTime,
                    endTime: endTime
                ))
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
                .andThen(Single.just(PiCKStep.tabIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false))
    }
    
}
