import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class WeekendMealApplyViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let weekendMealStatusUseCase: WeekendMealStatusUseCase
    private let weekendMealApplyUseCase: WeekendMealApplyUseCase

    public init(
        weekendMealStatusUseCase: WeekendMealStatusUseCase,
        weekendMealApplyUseCase: WeekendMealApplyUseCase
    ) {
        self.weekendMealStatusUseCase = weekendMealStatusUseCase
        self.weekendMealApplyUseCase = weekendMealApplyUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let applyStatus: Observable<WeekendMealType>
        let clickApplyButton: Observable<Void>
    }
    public struct Output {
        let weekendMealStatus: Signal<WeekendMealType>
    }

    private let weekendMealStatusRelay = PublishRelay<WeekendMealType>()

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.weekendMealStatusUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
                    .map {
                        return WeekendMealType(rawValue: $0.status) ?? .ok
                    }
            }
            .bind {
                self.weekendMealStatusRelay.accept($0)
            }
            .disposed(by: disposeBag)

        input.applyStatus
            .bind {
                self.weekendMealStatusRelay.accept($0)
            }
            .disposed(by: disposeBag)

        input.clickApplyButton
            .withLatestFrom(self.weekendMealStatusRelay)
            .flatMap { status in
                self.weekendMealApplyUseCase.execute(status: status)
                    .catch {
                        self.steps.accept(
                            PiCKStep.applyAlertIsRequired(
                                successType: .fail,
                                alertType: .weekendMeal
                            )
                        )
                        print($0.localizedDescription)
                        return .never()
                    }
                    .andThen(
                        Single.just(
                            PiCKStep.applyAlertIsRequired(
                                successType: .success,
                                alertType: .weekendMeal
                            ))
                    )
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(weekendMealStatus: weekendMealStatusRelay.asSignal())
    }

}
