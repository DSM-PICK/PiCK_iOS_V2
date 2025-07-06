import Foundation

import RxSwift
import RxCocoa
import RxFlow

import Core
import Domain

public class ChangePasswordViewModel: BaseViewModel, Stepper {
    public typealias Input = <#type#>
    
    public typealias Output = <#type#>
    
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()
}
