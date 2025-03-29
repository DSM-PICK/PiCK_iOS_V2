import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class HomeViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let userDefaultStorage = UserDefaultStorage.shared

    private let fetchApplyStatusUseCase: FetchApplyStatusUsecase
    private let fetchWeekendMealPeriodUseCase: FetchWeekendMealPeriodUseCase
    private let timeTableUseCase: FetchTodayTimeTableUseCase
    private let schoolMealUseCase: FetchSchoolMealUseCase
    private let noticeListUseCase: FetchSimpleNoticeListUseCase
    private let selfStudyUseCase: FetchSelfStudyUseCase
    private let fetchOutingPassUseCase: FetchOutingPassUseCase
    private let fetchEarlyLeavePassUseCase: FetchEarlyLeavePassUseCase
    private let classroomReturnUseCase: ClassroomReturnUseCase
    private let fetchProfileUseCase: FetchSimpleProfileUseCase

    public init(
        fetchApplyStatusUseCase: FetchApplyStatusUsecase,
        fetchWeekendMealPeriodUseCase: FetchWeekendMealPeriodUseCase,
        timeTableUseCase: FetchTodayTimeTableUseCase,
        schoolMealUseCase: FetchSchoolMealUseCase,
        noticeListUseCase: FetchSimpleNoticeListUseCase,
        selfStudyUseCase: FetchSelfStudyUseCase,
        fetchOutingPassUseCase: FetchOutingPassUseCase,
        fetchEarlyLeavePassUseCase: FetchEarlyLeavePassUseCase,
        classroomReturnUseCase: ClassroomReturnUseCase,
        fetchProfileUseCase: FetchSimpleProfileUseCase
    ) {
        self.fetchApplyStatusUseCase = fetchApplyStatusUseCase
        self.fetchWeekendMealPeriodUseCase = fetchWeekendMealPeriodUseCase
        self.timeTableUseCase = timeTableUseCase
        self.schoolMealUseCase = schoolMealUseCase
        self.noticeListUseCase = noticeListUseCase
        self.selfStudyUseCase = selfStudyUseCase
        self.fetchOutingPassUseCase = fetchOutingPassUseCase
        self.fetchEarlyLeavePassUseCase = fetchEarlyLeavePassUseCase
        self.classroomReturnUseCase = classroomReturnUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
    }

    public struct Input {
        let todayDate: String
        let viewWillAppear: Observable<Void>
        let clickAlert: Observable<Void>
        let clickOutingPass: Observable<Void>
        let clickViewMoreNotice: Observable<Void>
        let clickNotice: Observable<UUID>
    }
    public struct Output {
        let viewMode: Signal<HomeViewType>
        let profileData: Signal<SimpleProfileEntity>
        let applyStatusData: Signal<HomeApplyStatusEntity?>
        let weekendMealPeriodData: Signal<WeekendMealPeriodEntity>
        let timetableData: Driver<[TimeTableEntityElement]>
        let schoolMealData: Driver<[(String, MealEntityElement)]>
        let noticeListData: Signal<NoticeListEntity>
        let selfStudyData: Driver<SelfStudyEntity>
        let outingPassData: Signal<OutingPassEntity>
        let timeTableHeight: Driver<CGFloat>
        let schoolMealHeight: Driver<CGFloat>
        let noticeViewHeight: Driver<CGFloat>
    }

    private let viewModeData = PublishRelay<HomeViewType>()
    private let profileData = PublishRelay<SimpleProfileEntity>()
    private let applyStatusData = PublishRelay<HomeApplyStatusEntity?>()
    private let weekendMealPeriodData = PublishRelay<WeekendMealPeriodEntity>()
    private let timetableData = BehaviorRelay<[TimeTableEntityElement]>(value: [])
    private let schoolMealData = BehaviorRelay<[(String, MealEntityElement)]>(value: [])
    private let outingPassData = PublishRelay<OutingPassEntity>()
    private let noticeListData = PublishRelay<NoticeListEntity>()
    private let selfStudyData = BehaviorRelay<SelfStudyEntity>(value: [])
    private let timeTableHeight = BehaviorRelay<CGFloat>(value: 0)
    private let schoolMealHeight = BehaviorRelay<CGFloat>(value: 0)
    private let noticeViewHeight = BehaviorRelay<CGFloat>(value: 0)

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .subscribe(onNext: { [weak self] in
                if let data = self?.userDefaultStorage.getUserDataType(forKey: .homeViewMode, type: HomeViewType.self) {
                    self?.viewModeData.accept(data as? HomeViewType ?? .timeTable)
                } else {
                    self?.userDefaultStorage.setUserDataType(to: HomeViewType.timeTable, forKey: .homeViewMode)
                    self?.viewModeData.accept(.timeTable)
                }
            }).disposed(by: disposeBag)

        input.viewWillAppear
            .flatMap {
                self.fetchWeekendMealPeriodUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: weekendMealPeriodData)
            .disposed(by: disposeBag)

        input.viewWillAppear
            .flatMap {
                self.fetchProfileUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { data in
                let infoValue = "\(data.grade)학년 \(data.classNum)반 \(data.num)번 \(data.name)"

                self.userDefaultStorage.set(to: infoValue, forKey: .userInfoData)
                self.userDefaultStorage.set(to: data.name, forKey: .userNameData)
                self.profileData.accept(data)
            }).disposed(by: disposeBag)

        input.viewWillAppear
            .flatMap {
                self.fetchApplyStatusUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .just(nil)
                    }
            }
            .bind(to: applyStatusData)
            .disposed(by: disposeBag)

        input.viewWillAppear
            .flatMap {
                self.timeTableUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] data in
                self?.timetableData.accept(data.timetables)

                let height = CGFloat(data.timetables.count * 55)
                self?.timeTableHeight.accept(height)
            }).disposed(by: disposeBag)

        input.viewWillAppear
            .flatMap {
                self.schoolMealUseCase.execute(date: input.todayDate)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] data in
                self?.schoolMealData.accept(data.meals.mealBundle)

                let height = CGFloat(data.meals.mealBundle.count * 150)
                self?.schoolMealHeight.accept(height)
            }).disposed(by: disposeBag)

        input.viewWillAppear
            .flatMap {
                self.noticeListUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] data in
                self?.noticeListData.accept(data)
                let height = CGFloat(data.count)
                self?.noticeViewHeight.accept(height * 86)
            }).disposed(by: disposeBag)

        input.viewWillAppear
            .flatMap {
                self.selfStudyUseCase.execute(date: input.todayDate)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: selfStudyData)
            .disposed(by: disposeBag)

        input.clickOutingPass
            .flatMap {
                self.fetchOutingPassUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: outingPassData)
            .disposed(by: disposeBag)

        input.clickOutingPass
            .flatMap {
                self.fetchEarlyLeavePassUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: outingPassData)
            .disposed(by: disposeBag)

        input.clickOutingPass
            .flatMap {
                self.classroomReturnUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.clickAlert
            .map { PiCKStep.alertIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickViewMoreNotice
            .map { PiCKStep.noticeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.clickNotice
            .map { id in
                PiCKStep.noticeDetailIsRequired(id: id)
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(
            viewMode: viewModeData.asSignal(),
            profileData: profileData.asSignal(),
            applyStatusData: applyStatusData.asSignal(),
            weekendMealPeriodData: weekendMealPeriodData.asSignal(),
            timetableData: timetableData.asDriver(),
            schoolMealData: schoolMealData.asDriver(),
            noticeListData: noticeListData.asSignal(),
            selfStudyData: selfStudyData.asDriver(),
            outingPassData: outingPassData.asSignal(),
            timeTableHeight: timeTableHeight.asDriver(),
            schoolMealHeight: schoolMealHeight.asDriver(),
            noticeViewHeight: noticeViewHeight.asDriver()
        )
    }

}
