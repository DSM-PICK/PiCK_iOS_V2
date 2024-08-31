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
        let weekendMealStatus: Signal<WeekendMealStatusEntity>
    }

    private let weekendMealStatus = PublishRelay<WeekendMealStatusEntity>()

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.weekendMealStatusUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: weekendMealStatus)
            .disposed(by: disposeBag)

        input.applyStatus
//            .withLatestFrom(input.applyStatus)
            .flatMap { status in
                self.weekendMealApplyUseCase.execute(status: status)
                    .catch {
                        self.steps.accept(
                            PiCKStep.applyAlertIsRequired(
                                successType: .fail,
                                alertType: .weekendMeal
                            ))
                        print($0.localizedDescription)
                        return .never()
                    }
                    .andThen(Single.just(
                        PiCKStep.applyAlertIsRequired(
                        successType: .success,
                        alertType: .weekendMeal
                    )))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(weekendMealStatus: weekendMealStatus.asSignal())
    }

}
