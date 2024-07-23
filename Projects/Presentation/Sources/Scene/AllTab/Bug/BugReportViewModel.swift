import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class BugReportViewModel: BaseViewModel, Stepper {
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
    
    public init() {}
    
    public struct Input {}
    public struct Output {}
    
    public func transform(input: Input) -> Output {
        return Output()
    }
    
}
