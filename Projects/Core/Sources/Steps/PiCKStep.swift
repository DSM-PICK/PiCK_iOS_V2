import Foundation

import RxFlow

public enum PiCKStep: Step {
    //start
    case onboardingIsRequired
    case loginIsRequired

    //tab
    case tabIsRequired

    //home
    case homeIsRequired
    case alertIsRequired

    //schoolMeal
    case schoolMealIsRequired

    //apply
    case applyIsRequired

    //schedule
    case scheduleIsRequired

    //allTab
    case allTabIsRequired
    case noticeIsRequired
    case noitceDetailIsRequired
    case selfStudyIsRequired
    case bugReportIsRequired
    case myPageIsRequired
    case logoutIsRequired

    //test
    case testIsRequired

}
