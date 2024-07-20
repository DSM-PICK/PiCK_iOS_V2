import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class OnboardingViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {
        let clickOnboardingButton: Observable<Void>
    }
    public struct Output {}
    
    public func transform(input: Input) -> Output {
        input.clickOnboardingButton
            .map { PiCKStep.loginIsRequired }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        return Output()
    }
    
}
