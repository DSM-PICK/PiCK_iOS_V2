import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class EarlyLeaveApplyViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let earlyLeaveApplyUseCase: EarlyLeaveApplyUseCase

    public init(earlyLeaveApplyUseCase: EarlyLeaveApplyUseCase) {
        self.earlyLeaveApplyUseCase = earlyLeaveApplyUseCase
    }

    public struct Input {
        let startTime: Observable<String>
        let clickStartTime: Observable<Void>
        let reasonText: Observable<String?>
        let clickEarlyLeaveApply: Observable<Void>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }

    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.reasonText,
            input.startTime
        )

        let isApplyButtonEnable = info.map { reason, startTime -> Bool in !reason!.isEmpty && !startTime.isEmpty
        }

        input.clickEarlyLeaveApply
            .withLatestFrom(info)
            .flatMap { reason, startTime in
                self.earlyLeaveApplyUseCase.execute(req: .init(
                    reason: reason ?? "",
                    startTime: startTime
                ))
                .catch {
                    self.steps.accept(PiCKStep.applyAlertIsRequired(
                        successType: .fail,
                        alertType: .earlyLeave
                    ))
                    print($0.localizedDescription)
                    return .never()
                }
                .andThen(Single.just(PiCKStep.applyAlertIsRequired(
                    successType: .success,
                    alertType: .earlyLeave
                )))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false))
    }

}
