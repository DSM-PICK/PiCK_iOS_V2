import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ScheduleViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let fetchWeekTimeTableUseCase: FetchWeekTimeTableUseCase

    public init(
        fetchWeekTimeTableUseCase: FetchWeekTimeTableUseCase
    ) {
        self.fetchWeekTimeTableUseCase = fetchWeekTimeTableUseCase
    }

    public struct Input {
        let loadTimeTable: Observable<Void>
    }
    public struct Output {
        let timeTableData: Driver<WeekTimeTableEntity>
    }

    let timeTableData = BehaviorRelay<WeekTimeTableEntity>(value: [])

    public func transform(input: Input) -> Output {
        input.loadTimeTable
            .flatMap {
                self.fetchWeekTimeTableUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: timeTableData)
            .disposed(by: disposeBag)

        return Output(
            timeTableData: timeTableData.asDriver()
        )
    }

}
