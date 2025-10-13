import Foundation

import RxFlow

public enum PiCKStep: Step {
    // start
    case appIsRequired
    case onboardingIsRequired
    case signinIsRequired

    // tab
    case tabIsRequired
    case popIsRequired

    // MARK: Signup
    case verifyEmailIsRequired
    case passwordSettingIsRequired(email: String, verificationCode: String)
    case infoSettingIsRequired(email: String, password: String, verificationCode: String)
    case signupComplete

    // MARK: home
    case homeIsRequired
    case alertIsRequired

    // MARK: schoolMeal
    case schoolMealIsRequired

    // MARK: apply
    case applyIsRequired
    case applyAlertIsRequired(successType: SuccessType, alertType: DisappearAlertType)
    // weekendMeal
    case weekendMealApplyIsRequired
    // classroom
    case classroomMoveApplyIsRequired
    // outing
    case outingApplyIsRequired
    // earlyLeave
    case earlyLeaveApplyIsRequired

    // MARK: schedule
    case scheduleIsRequired

    // MARK: AllTab
    case allTabIsRequired
    case noticeIsRequired
    case noticeDetailIsRequired(id: UUID)
    case selfStudyIsRequired
    case bugReportIsRequired
    case customIsRequired
    case notificationSettingIsRequired
    case myPageIsRequired
    case logoutIsRequired

    // MARK: ChangePassword
    case changePasswordIsRequired
    case newPasswordIsRequired(acountId: String, verificationCode: String)

    // MARK: test
    case testIsRequired

}
