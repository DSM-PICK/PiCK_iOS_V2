import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class NoticeDetailViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let noticeDetailUseCase: FetchDetailNoticeUseCase

    public init(noticeDetailUseCase: FetchDetailNoticeUseCase) {
        self.noticeDetailUseCase = noticeDetailUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<UUID>
    }
    public struct Output {
        let noticeDetailData: Signal<DetailNoticeEntity>
    }

    private let noticeDetailData = PublishRelay<DetailNoticeEntity>()

    public func transform(input: Input) -> Output {
        input.viewWillAppear.asObservable()
            .flatMap { id in
                self.noticeDetailUseCase.execute(id: id)
                    .catch {
                        print($0.localizedDescription)
                        return .never()
                    }
            }
            .bind(to: noticeDetailData)
            .disposed(by: disposeBag)

        return Output(noticeDetailData: noticeDetailData.asSignal())
    }

}
