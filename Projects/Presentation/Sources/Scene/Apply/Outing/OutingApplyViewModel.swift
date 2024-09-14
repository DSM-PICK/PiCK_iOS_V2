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
        let applicationType: Observable<PickerTimeSelectType>
        let clickOutingApply: Observable<Void>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }

    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.reasonText,
            input.startTime,
            input.endTime,
            input.applicationType
        )
        
        let isApplyButtonEnable = info.map { reason, startTime, endTime, _ -> Bool in
            !reason!.isEmpty && !startTime.isEmpty && !endTime.isEmpty && startTime < endTime
        }

        input.clickOutingApply.asObservable()
            .withLatestFrom(info)
            .flatMap { reason, startTime, endTime, applicationType in
                self.outingApplyUseCase.execute(req: .init(
                    reason: reason ?? "",
                    startTime: startTime,
                    endTime: endTime,
                    applicationType: applicationType.rawValue
                ))
                .catch {
                    self.steps.accept(
                        PiCKStep.applyAlertIsRequired(
                            successType: .fail,
                            alertType: .outing
                        )
                    )
                    print($0.localizedDescription)
                    return .never()
                }
                .andThen(Single.just(PiCKStep.applyAlertIsRequired(
                    successType: .success,
                    alertType: .outing
                )))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false))
    }
    
}
