import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ChangePasswordViewModel: BaseViewModel, Stepper {
    public let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()
    
    init(
        
    ) {
        
    }
    
    public struct Input {
        
    }
    
    public struct Output {
        
    }
    
    public func transform(input: Input) -> Output {
        return Output()
    }
}
