import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class AllTabViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let fetchProfileUsecase: FetchSimpleProfileUseCase
    private let logoutUseCase: LogoutUseCase

    public init(
        fetchProfileUsecase: FetchSimpleProfileUseCase,
        logoutUseCase: LogoutUseCase
    ) {
        self.fetchProfileUsecase = fetchProfileUsecase
        self.logoutUseCase = logoutUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let selfStudyTabDidTap: Observable<IndexPath>
        let noticeTabDidTap: Observable<IndexPath>
        let bugReportTabDidTap: Observable<IndexPath>
        let customTabDidTap: Observable<IndexPath>
        let notificationSettingTabDidTap: Observable<IndexPath>
        let myPageTabDidTap: Observable<IndexPath>
        let logOutButtonDidTap: Observable<Void>
    }
    public struct Output {
        let profileData: Signal<SimpleProfileEntity>
    }

    private let profileData = PublishRelay<SimpleProfileEntity>()

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.fetchProfileUsecase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: profileData)
            .disposed(by: disposeBag)

        input.selfStudyTabDidTap
            .map { _ in PiCKStep.selfStudyIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.noticeTabDidTap
            .map { _ in PiCKStep.noticeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.bugReportTabDidTap
            .map { _ in PiCKStep.bugReportIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.customTabDidTap
            .map { _ in PiCKStep.customIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.notificationSettingTabDidTap
            .map { _ in PiCKStep.notificationSettingIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.myPageTabDidTap
            .map { _ in PiCKStep.myPageIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        input.logOutButtonDidTap
            .do(onNext: { _ in
                self.logoutUseCase.execute()
            })
            .map { PiCKStep.tabIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(profileData: profileData.asSignal())
    }

}
