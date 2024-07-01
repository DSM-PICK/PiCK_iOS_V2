import Foundation

import RxSwift
import RxCocoa
import RxFlow

public enum PiCKStep: Step {
    
    //start
    case onboardingIsRequired
    case loginIsRequired
    
    //test
    case testIsRequired

}
