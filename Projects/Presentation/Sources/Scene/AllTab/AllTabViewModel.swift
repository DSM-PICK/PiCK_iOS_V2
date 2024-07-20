import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class AllTabViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {
        let clickNoticeTab: Observable<IndexPath>
    }
    public struct Output {}
    
    public func transform(input: Input) -> Output {
        input.clickNoticeTab
            .map { _ in PiCKStep.noticeIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
    
}
