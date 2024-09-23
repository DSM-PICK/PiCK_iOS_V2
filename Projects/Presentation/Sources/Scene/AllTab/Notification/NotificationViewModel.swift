import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class NotificationViewModel: BaseViewModel, Stepper {
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
        let outingStatus: Observable<Bool>
        let classroomStatus: Observable<Bool>
        let newNoticeStatus: Observable<Bool>
        let weekendMealStatus: Observable<Bool>
    }
    public struct Output {
        let notificationStatus: Signal<NotificationEntity>
    }

    private let notificationStatus = PublishRelay<NotificationEntity>()

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.fetchNotificationStatusUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .subscribe(onNext: { [weak self] status in
                self?.notificationStatus.accept(status)
            }).disposed(by: disposeBag)

        input.outingStatus
            .skip(1)
            .flatMap { isSubscribed in
                self.notificationSubscribeUseCase.execute(req: .init(
                    type: .application,
                    isSubscribed: isSubscribed
                ))
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        input.outingStatus
            .skip(1)
            .flatMap { isSubscribed in
                self.notificationSubscribeUseCase.execute(req: .init(
                    type: .application,
                    isSubscribed: isSubscribed
                ))
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
                self.notificationSubscribeUseCase.execute(req: .init(
                    type: .classroom,
                    isSubscribed: isSubscribed
                ))
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
                self.notificationSubscribeUseCase.execute(req: .init(
                    type: .newNotice,
                    isSubscribed: isSubscribed
                ))
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
                self.notificationSubscribeUseCase.execute(req: .init(
                    type: .weekendMeal,
                    isSubscribed: isSubscribed
                ))
                .catch {
                    print($0.localizedDescription)
                    return .never()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Output(notificationStatus: notificationStatus.asSignal())
    }

}
