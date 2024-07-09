import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class LoginViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {
        let loginButtonClick: Observable<Void>
    }
    public struct Output {}
    
    public func transform(input: Input) -> Output {
        input.loginButtonClick
            .map { PiCKStep.tabIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output()
    }
    
}
