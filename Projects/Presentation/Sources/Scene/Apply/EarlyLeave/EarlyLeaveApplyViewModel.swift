import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class EarlyLeaveApplyViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    private let isApplying = BehaviorRelay<Bool>(value: false)

    private let earlyLeaveApplyUseCase: EarlyLeaveApplyUseCase

    public init(earlyLeaveApplyUseCase: EarlyLeaveApplyUseCase) {
        self.earlyLeaveApplyUseCase = earlyLeaveApplyUseCase
    }

    public struct Input {
        let startTime: Observable<String>
        let selectStartTimeButtonDidTap: Observable<Void>
        let reasonText: Observable<String?>
        let applicationType: Observable<PickerTimeSelectType>
        let earlyLeaveApplyButtonDidTap: Observable<Void>
    }
    public struct Output {
        let isApplyButtonEnable: Signal<Bool>
    }

    public func transform(input: Input) -> Output {
        let info = Observable.combineLatest(
            input.reasonText,
            input.startTime,
            input.applicationType
        )

        let isApplyButtonEnable = Observable.combineLatest(
            info,
            isApplying
        ) { info, isApplying in
            let (reason, startTime, _) = info
            return (reason?.isEmpty == false && !startTime.isEmpty) && !isApplying
        }

        input.earlyLeaveApplyButtonDidTap
            .withLatestFrom(info)
            .do(onNext: { [weak self] _ in
                self?.isApplying.accept(true)
            })
            .flatMap { reason, startTime, applicationType in
                self.earlyLeaveApplyUseCase.execute(req: .init(
                    reason: reason ?? "",
                    startTime: applicationType == .period
                        ? "\(startTime)교시"
                        : startTime,
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
                            alertType: .earlyLeave
                        )
                    )
                    print($0.localizedDescription)
                    return .never()
                }
                .andThen(
                    Single.just(
                        PiCKStep.applyAlertIsRequired(
                            successType: .success,
                            alertType: .earlyLeave
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
