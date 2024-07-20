import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class NoticeListViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {
        let clickNotice: Observable<Void>
    }
    public struct Output {}
    
    public func transform(input: Input) -> Output {
        input.clickNotice
            .map { PiCKStep.noitceDetailIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)

        return Output()
    }
    
}
