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
        let clickNotice: Observable<Void>
    }
    public struct Output {
        let noticeListData: Signal<NoticeListEntity>
    }

    private let noticeListData = PublishRelay<NoticeListEntity>()

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

        input.clickNotice
            .map { PiCKStep.noitceDetailIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output(noticeListData: noticeListData.asSignal())
    }
    
}
