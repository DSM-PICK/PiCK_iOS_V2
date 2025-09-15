import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core
import DesignSystem

final public class PasswordSettingViewController: BaseViewController<PasswordSettingViewModel> {
    public var email: String = ""
    public var verificationCode: String = ""

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
    private let passwordTextField = PiCKTextField(
        titleText: "비밀번호",
        placeholder: "비밀번호를 입력하세요",
        buttonIsHidden: true
    ).then {
        $0.isSecurity = true
    }
    private let confirmPasswordField = PiCKTextField(
        titleText: "비밀번호 확인",
        placeholder: "비밀번호를 입력하세요",
        buttonIsHidden: false
    ).then {
        $0.isSecurity = true
    }
    private let nextButton = PiCKButton(
        buttonText: "다음",
        isHidden: false
    )

    public override func attribute() {
        super.attribute()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    public override func bind() {
        let input = PasswordSettingViewModel.Input(
            email: email,
            verificationCode: verificationCode,
            nextButtonTap: nextButton.rx.tap.asObservable(),
            passwordText: passwordTextField.rx.text.orEmpty.asObservable(),
            confirmPasswordText: confirmPasswordField.rx.text.orEmpty.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.isNextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            passwordTextField,
            confirmPasswordField,
            nextButton
        ].forEach(view.addSubview)
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(75)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        confirmPasswordField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(71)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
