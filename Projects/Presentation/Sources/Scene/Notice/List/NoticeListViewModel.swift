import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class NoticeListViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let noticeListUseCase: FetchNoticeListUseCase

    public init(steps: PublishRelay<any Step> = PublishRelay<Step>(), noticeListUseCase: FetchNoticeListUseCase) {
        self.steps = steps
        self.noticeListUseCase = noticeListUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
        let clickNoticeCell: Observable<UUID>
    }
    public struct Output {
        let noticeListData: Driver<NoticeListEntity>
    }

    private let noticeListData = BehaviorRelay<NoticeListEntity>(value: [])

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.noticeListUseCase.execute()
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: noticeListData)
            .disposed(by: disposeBag)

        input.clickNoticeCell
            .map { id in
                PiCKStep.noticeDetailIsRequired(id: id)
            }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(noticeListData: noticeListData.asDriver())
    }

}
