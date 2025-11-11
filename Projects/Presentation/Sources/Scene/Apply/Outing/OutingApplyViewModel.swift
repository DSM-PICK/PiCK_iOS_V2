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
    private let isApplying = BehaviorRelay<Bool>(value: false)

    public init(outingApplyUseCase: OutingApplyUseCase) {
        self.outingApplyUseCase = outingApplyUseCase
    }

    private func isApplyButtonEnable(reason: String?, startTime: String, endTime: String, outingType: PickerTimeSelectType) -> Bool {
        guard let reason = reason, !reason.isEmpty, !startTime.isEmpty, !endTime.isEmpty else {
            return false
        }
        if outingType == .period {
            let startPeriod = Int(startTime) ?? 0
            let endPeriod = Int(endTime) ?? 0
            return startPeriod <= endPeriod
        }
        return startTime <= endTime
    }

    public struct Input {
        let startTime: Observable<String>
        let selectStartTimeButtonDidTap: Observable<Void>
        let endTime: Observable<String>
        let selectEndTimeButtonDidTap: Observable<Void>
        let reasonText: Observable<String?>
        let applicationType: Observable<PickerTimeSelectType>
        let outingApplyButtonDidTap: Observable<Void>
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

        let isApplyButtonEnable = Observable.combineLatest(
            info,
            isApplying
        ) { info, isApplying in
            let (reason, startTime, endTime, outingType) = info
            return (self.isApplyButtonEnable(
                reason: reason,
                startTime: startTime,
                endTime: endTime,
                outingType: outingType
            ) && !isApplying)
        }

        input.outingApplyButtonDidTap
            .withLatestFrom(info)
            .do(onNext: { [weak self] _ in
                self?.isApplying.accept(true)
            })
            .flatMap { reason, startTime, endTime, applicationType in
                self.outingApplyUseCase.execute(req: .init(
                    reason: reason ?? "",
                    startTime: applicationType == .period ?
                    "\(startTime)교시" : startTime,
                    endTime: applicationType == .period ?
                    "\(endTime)교시" : endTime,
                    applicationType: applicationType.rawValue
                ))
                .do(onError: { [weak self] _ in
                    self?.isApplying.accept(false)
                }, onCompleted: { [weak self] in
                    self?.isApplying.accept(false)
                })
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
                .andThen(
                    Single.just(
                        PiCKStep.applyAlertIsRequired(
                            successType: .success,
                            alertType: .outing
                        )
                    )
                )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            isApplyButtonEnable: isApplyButtonEnable.asSignal(onErrorJustReturn: false)
        )
    }

}