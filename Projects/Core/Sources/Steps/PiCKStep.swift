import Foundation

import RxFlow

public enum PiCKStep: Step {
    //start
    case appIsRequired
    case onboardingIsRequired
    case loginIsRequired

    //tab
    case tabIsRequired
    case popIsRequired

    //home
    case homeIsRequired
    case alertIsRequired

    //schoolMeal
    case schoolMealIsRequired

    //MARK: apply
    case applyIsRequired
    case applyAlertIsRequired(successType: SuccessType, alertType: DisappearAlertType)
    //weekendMeal
    case weekendMealApplyIsRequired
    //classroom
    case classroomMoveApplyIsRequired
    //outing
    case outingApplyIsRequired
    //earlyLeave
    case earlyLeaveApplyIsRequired

    //schedule
    case scheduleIsRequired

    //MARK: AllTab
    case allTabIsRequired
    case noticeIsRequired
    case noticeDetailIsRequired(id: UUID)
    case selfStudyIsRequired
    case bugReportIsRequired
    case customIsRequired
    case notificationSettingIsRequired
    case myPageIsRequired
    case logoutIsRequired

    //test
    case testIsRequired

}
