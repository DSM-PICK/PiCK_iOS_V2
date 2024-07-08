import Foundation

import RxFlow

public enum PiCKStep: Step {
    
    //start
    case onboardingIsRequired
    case loginIsRequired
    
    case tabIsRequired
    
    //home
    case homeIsRequired
    
    //schoolMeal
    case schoolMealIsRequired
    
    //apply
    case applyIsRequired
    
    //schedule
    case scheduleIsRequired
    
    //allTab
    case allTabIsRequired
    
    //test
    case testIsRequired

}
