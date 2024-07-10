import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class HomeViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {
        let clickAlertButton: Observable<Void>
    }
    public struct Output {}
    
    public func transform(input: Input) -> Output {
        
        input.clickAlertButton
            .map { PiCKStep.alertIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output()
    }
    
}
