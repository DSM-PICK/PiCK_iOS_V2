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
    private let selfStudyUseCase: FetchSelfStudyUseCase

    public init(
        timeTableUseCase: FetchTodayTimeTableUseCase,
        schoolMealUseCase: FetchSchoolMealUseCase,
        noticeListUseCase: FetchNoticeListUseCase,
        selfStudyUseCase: FetchSelfStudyUseCase
    ) {
        self.timeTableUseCase = timeTableUseCase
        self.schoolMealUseCase = schoolMealUseCase
        self.noticeListUseCase = noticeListUseCase
        self.selfStudyUseCase = selfStudyUseCase
    }

    public struct Input {
        let viewWillApper: Observable<Void>
        let clickAlert: Observable<Void>
        let clickViewMoreNotice: Observable<Void>
        let todayDate: String
    }
    public struct Output {
        let viewMode: Signal<HomeViewType>
        let timetableData: Driver<[TimeTableEntityElement]>
        let schoolMealData: Driver<[(Int, String, MealEntityElement)]>
        let noticeListData: Driver<NoticeListEntity>
        let selfStudyData: Driver<SelfStudyEntity>
        let timeTableHeight: Driver<CGFloat>
        let schoolMealHeight: Driver<CGFloat>
        let noticeViewHeight: Driver<CGFloat>
    }

    private let viewModeData = PublishRelay<HomeViewType>()
    private let timetableData = BehaviorRelay<[TimeTableEntityElement]>(value: [])
    private let schoolMealData = BehaviorRelay<[(Int, String, MealEntityElement)]>(value: [])
    private let noticeListData = BehaviorRelay<NoticeListEntity>(value: [])
    private let selfStudyData = BehaviorRelay<SelfStudyEntity>(value: [])
    private let timeTableHeight = PublishRelay<CGFloat>()
    private let schoolMealHeight = PublishRelay<CGFloat>()
    private let noticeViewHeight = PublishRelay<CGFloat>()

    public func transform(input: Input) -> Output {
        input.viewWillApper
            .subscribe(onNext: { [weak self] in
                let data = UserDefaultsManager.shared.getUserDataType(forKey: .homeViewMode, type: HomeViewType.self)
 
                self?.viewModeData.accept(data as! HomeViewType)
            }).disposed(by: disposeBag)

        input.viewWillApper
            .flatMap {
                self.timeTableUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] data in
                self?.timetableData.accept(data.timetables)

                let height = CGFloat(data.timetables.count * 50)
                self?.timeTableHeight.accept(height)
            }).disposed(by: disposeBag)

        input.viewWillApper.asObservable()
            .flatMap { date in
                self.schoolMealUseCase.execute(date: input.todayDate)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] data in
                self?.schoolMealData.accept(data.meals.mealBundle)

                let height = CGFloat(data.meals.mealBundle.count * 102)
                self?.schoolMealHeight.accept(height)
            }).disposed(by: disposeBag)

        input.viewWillApper
            .flatMap {
                self.noticeListUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] noticeData in
                let value = Array(noticeData.prefix(5))
                self?.noticeListData.accept(value)
                let height = CGFloat(value.count)
                self?.noticeViewHeight.accept(height * 86)
            }).disposed(by: disposeBag)

        input.viewWillApper
            .flatMap {
                self.selfStudyUseCase.execute(date: input.todayDate)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: selfStudyData)
            .disposed(by: disposeBag)

        input.clickAlert
            .map { PiCKStep.alertIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickViewMoreNotice
            .map { PiCKStep.noticeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            viewMode: viewModeData.asSignal(), 
            timetableData: timetableData.asDriver(),
            schoolMealData: schoolMealData.asDriver(),
            noticeListData: noticeListData.asDriver(),
            selfStudyData: selfStudyData.asDriver(),
            timeTableHeight: timeTableHeight.asDriver(onErrorJustReturn: 0),
            schoolMealHeight: schoolMealHeight.asDriver(onErrorJustReturn: 0),
            noticeViewHeight: noticeViewHeight.asDriver(onErrorJustReturn: 0)
        )
    }

}
