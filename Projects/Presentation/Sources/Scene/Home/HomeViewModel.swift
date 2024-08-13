import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class HomeViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let timeTableUseCase: FetchTodayTimeTableUseCase
    private let schoolMealUseCase: FetchSchoolMealUseCase
    private let noticeListUseCase: FetchNoticeListUseCase

    public init(
        timeTableUseCase: FetchTodayTimeTableUseCase,
        schoolMealUseCase: FetchSchoolMealUseCase,
        noticeListUseCase: FetchNoticeListUseCase
    ) {
        self.timeTableUseCase = timeTableUseCase
        self.schoolMealUseCase = schoolMealUseCase
        self.noticeListUseCase = noticeListUseCase
    }

    public struct Input {
        let viewWillApper: Observable<Void>
        let clickAlert: Observable<Void>
//        let loadSchoolMeal: Observable<String>
        let clickViewMore: Observable<Void>
    }
    public struct Output {
        let viewMode: Signal<HomeViewType>
        let timetableData: Driver<[TimeTableEntityElement]>
//        let schoolMealData: Driver<[SchoolMealEntityElement]>
        let noticeListData: Driver<NoticeListEntity>
    }

    private let viewModeData = PublishRelay<HomeViewType>()
    private let timetableData = BehaviorRelay<[TimeTableEntityElement]>(value: [])
//    private let schoolMealData = BehaviorRelay<[SchoolMeSchoolMealEntityElementalEntityElement]>(value: [])
    private let noticeListData = BehaviorRelay<NoticeListEntity>(value: [])

    public func transform(input: Input) -> Output {
//        input.viewWillApper
//            .map { _ in UserDefaultsManager.shared.get(forKey: .homeViewMode)}
//            .subscribe(onNext: { [weak self] data in
//                self?.viewModeData.accept(data as? HomeViewType ?? .timeTable)
//            }).disposed(by: disposeBag)
        input.viewWillApper
            .flatMap {
                self.timeTableUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] in
                self?.timetableData.accept($0.timetables)
            }).disposed(by: disposeBag)

//        input.loadSchoolMeal.asObservable()
//            .flatMap { date in
//                self.schoolMealUseCase.execute(date: date)
//                    .catch {
//                        print($0.localizedDescription)
//                        return .never()
//                    }
//            }
//            .subscribe(onNext: {
//                self.schoolMealData.accept($0.meals)
//            })
//            .disposed(by: disposeBag)

        input.viewWillApper
            .flatMap {
                self.noticeListUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: noticeListData)
            .disposed(by: disposeBag)

        input.clickAlert
            .map { PiCKStep.alertIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickViewMore
            .map { PiCKStep.noticeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            viewMode: viewModeData.asSignal(), 
            timetableData: timetableData.asDriver(),
//            schoolMealData: schoolMealData.asDriver(),SchoolMealEntityElement
            noticeListData: noticeListData.asDriver()
        )
    }

}
