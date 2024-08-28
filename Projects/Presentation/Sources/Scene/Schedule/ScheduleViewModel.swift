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
    private let fetchMonthAcademicScheduleUseCase: FetchMonthAcademicScheduleUseCase
    private let fetchAcademicScheduleUseCase: FetchAcademicScheduleUseCase

    public init(
        fetchWeekTimeTableUseCase: FetchWeekTimeTableUseCase,
        fetchMonthAcademicScheduleUseCase: FetchMonthAcademicScheduleUseCase,
        fetchAcademicScheduleUseCase: FetchAcademicScheduleUseCase
    ) {
        self.fetchWeekTimeTableUseCase = fetchWeekTimeTableUseCase
        self.fetchMonthAcademicScheduleUseCase = fetchMonthAcademicScheduleUseCase
        self.fetchAcademicScheduleUseCase = fetchAcademicScheduleUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let academicScheduleYearAndMonth: Observable<(String, String)>
        let academicScheduleDate: Observable<String>
    }
    public struct Output {
        let timeTableData: Driver<WeekTimeTableEntity>
        let monthAcademicScheduleData: Driver<AcademicScheduleEntity>
        let academicScheduleData: Driver<AcademicScheduleEntity>
    }

    private let timeTableData = BehaviorRelay<WeekTimeTableEntity>(value: [])
    private let monthAcademicScheduleData = BehaviorRelay<AcademicScheduleEntity>(value: [])
    private let academicScheduleData = BehaviorRelay<AcademicScheduleEntity>(value: [])

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.fetchWeekTimeTableUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: timeTableData)
            .disposed(by: disposeBag)

        input.academicScheduleYearAndMonth
            .flatMap { year, month in
                self.fetchMonthAcademicScheduleUseCase.execute(req: .init(
                    year: year,
                    month: month
                ))
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
            }
            .bind(to: monthAcademicScheduleData)
            .disposed(by: disposeBag)

        input.academicScheduleDate
            .flatMap { date in
                self.fetchAcademicScheduleUseCase.execute(date: date)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: academicScheduleData)
            .disposed(by: disposeBag)

        return Output(
            timeTableData: timeTableData.asDriver(),
            monthAcademicScheduleData: monthAcademicScheduleData.asDriver(),
            academicScheduleData: academicScheduleData.asDriver()
        )
    }

}
