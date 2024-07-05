import Foundation

import RxFlow

public enum PiCKStep: Step {
    
    //start
    case onboardingIsRequired
    case loginIsRequired
    
    //main
    case mainIsRequired
    
    //test
    case testIsRequired

}
