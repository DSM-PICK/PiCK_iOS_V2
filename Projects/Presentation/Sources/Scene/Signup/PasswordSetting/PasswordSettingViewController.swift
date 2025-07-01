import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core
import DesignSystem

final public class PasswordSettingViewController: BaseViewController<PasswordSettingViewModel> {
    private let titleLabel = PiCKLabel(
        text: "PiCK에 회원가입하기",
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    ).then {
        $0.changePointColor(targetString: "PiCK", color: .main500)
    }
    private let explainLabel = PiCKLabel(
        text: "사용할 비밀번호를 입력 해주세요.",
        textColor: .gray600,
        font: .pickFont(.body1)
    )
    private let emailTextField = PiCKTextField(
        titleText: "비밀번호",
        placeholder: "비밀번호를 입력하세요",
        buttonIsHidden: true
    )
    private let certificationField = PiCKTextField(
        titleText: "비밀번호 확인",
        placeholder: "비밀 번호를 입력하세요",
        buttonIsHidden: false
    ).then {
        $0.isSecurity = true
    }
    private let nextButton = PiCKButton(
        buttonText: "다음",
        isHidden: false
    )
    
    

}
