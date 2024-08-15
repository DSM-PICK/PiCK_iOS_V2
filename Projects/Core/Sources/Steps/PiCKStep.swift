import Foundation

import RxFlow

public enum PiCKStep: Step {
    //start
    case appIsRequired
    case onboardingIsRequired
    case loginIsRequired

    //tab
    case tabIsRequired

    //home
    case homeIsRequired
    case alertIsRequired

    //schoolMeal
    case schoolMealIsRequired

    //MARK: apply
    case applyIsRequired
    case applyAlertIsRequired(successType: SuccessType, alertType: DisappearAlertType)
    case timeSelectAlertIsRequired
    //weekendMeal
    case weekendMealApplyIsRequired
    //classRoom
    case classRoomMoveApplyIsRequired
    //outing
    case outingApplyIsRequired
    //earlyLeave
    case earlyLeaveApplyIsRequired

    //schedule
    case scheduleIsRequired

    //MARK: AllTab
    case allTabIsRequired
    case noticeIsRequired
    case noitceDetailIsRequired(id: UUID)
    case selfStudyIsRequired
    case bugReportIsRequired
    case myPageIsRequired
    case logoutIsRequired

    //test
    case testIsRequired

}
