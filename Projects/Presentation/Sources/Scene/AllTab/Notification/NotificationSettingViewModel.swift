import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class NotificationSettingViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let fetchNotificationStatusUseCase: FetchNotificationStatus
    private let notificationSubscribeUseCase: NotificationSubscribeUseCase

    public init(
        fetchNotificationStatusUseCase: FetchNotificationStatus,
        notificationSubscribeUseCase: NotificationSubscribeUseCase
    ) {
        self.fetchNotificationStatusUseCase = fetchNotificationStatusUseCase
        self.notificationSubscribeUseCase = notificationSubscribeUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let allStatus: Observable<Bool>
        let outingStatus: Observable<Bool>
        let classroomStatus: Observable<Bool>
        let newNoticeStatus: Observable<Bool>
        let weekendMealStatus: Observable<Bool>
    }
    public struct Output {
        let allNotificationStatus: Driver<Bool>
        let outingNotificationStatus: Driver<Bool>
        let classroomNotificationStatus: Driver<Bool>
        let newNoticeNotificationStatus: Driver<Bool>
        let weekendMealNotificationStatus: Driver<Bool>
    }

    private let subscribeNotificationList = PublishRelay<NotificationEntity>()
    private let allNotificationStatus = BehaviorRelay<Bool>(value: false)
    private let outingNotificationStatus = BehaviorRelay<Bool>(value: false)
    private let classroomNotificationStatus = BehaviorRelay<Bool>(value: false)
    private let newNoticeNotificationStatus = BehaviorRelay<Bool>(value: false)
    private let weekendMealNotificationStatus = BehaviorRelay<Bool>(value: false)

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.fetchNotificationStatusUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: subscribeNotificationList)
            .disposed(by: disposeBag)

        subscribeNotificationList
            .map { $0.subscribeTopicResponse }
            .subscribe(onNext: { [self] in
                for status in $0 {
                    if status.topic == .application {
                        outingNotificationStatus.accept(status.isSubscribed)
                    } else if status.topic == .classroom {
                        classroomNotificationStatus.accept(status.isSubscribed)
                    } else if status.topic == .newNotice {
                        newNoticeNotificationStatus.accept(status.isSubscribed)
                    } else if status.topic == .weekendMeal {
                        weekendMealNotificationStatus.accept(status.isSubscribed)
                    }

                    if (
                        outingNotificationStatus.value &&
                        classroomNotificationStatus.value &&
                        newNoticeNotificationStatus.value &&
                        weekendMealNotificationStatus.value
                    ) {
                        allNotificationStatus.accept(true)
                    } else {
                        allNotificationStatus.accept(false)
                    }
                }
            }).disposed(by: disposeBag)

//        input.allStatus
//            .skip(1)
//            .flatMap { isSubscribed in
//                
//            }

        input.outingStatus
            .skip(1)
            .flatMap { isSubscribed in
                self.notificationSubscribeUseCase.execute(
                    topic: .application,
                    isSubscribed: isSubscribed
                )
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.classroomStatus
            .skip(1)
            .flatMap { isSubscribed in
                self.notificationSubscribeUseCase.execute(
                    topic: .classroom,
                    isSubscribed: isSubscribed
                )
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.newNoticeStatus
            .skip(1)
            .flatMap { isSubscribed in
                self.notificationSubscribeUseCase.execute(
                    topic: .newNotice,
                    isSubscribed: isSubscribed
                )
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.weekendMealStatus
            .skip(1)
            .flatMap { isSubscribed in
                self.notificationSubscribeUseCase.execute(
                    topic: .weekendMeal,
                    isSubscribed: isSubscribed
                )
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(
            allNotificationStatus: allNotificationStatus.asDriver(),
            outingNotificationStatus: outingNotificationStatus.asDriver(),
            classroomNotificationStatus: classroomNotificationStatus.asDriver(),
            newNoticeNotificationStatus: newNoticeNotificationStatus.asDriver(),
            weekendMealNotificationStatus: weekendMealNotificationStatus.asDriver()
        )
    }

}
