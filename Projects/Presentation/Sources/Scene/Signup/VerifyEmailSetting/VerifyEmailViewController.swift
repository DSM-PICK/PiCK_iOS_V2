import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core
import DesignSystem

final public class VerifyEmailViewController: BaseViewController<VerifyEmailViewModel> {
    private let titleLabel = PiCKLabel(
        text: "PiCK에 회원가입하기",
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    ).then {
        $0.changePointColor(targetString: "PiCK", color: .main500)
    }
    private let explainLabel = PiCKLabel(
        text: "DSM 이메일로 인증 해주세요.",
        textColor: .gray600,
        font: .pickFont(.body1)
    )
    private let emailTextField = PiCKTextField(
        titleText: "이메일",
        placeholder: "학교 이메일을 입력해주세요",
        buttonIsHidden: true
    )
    private let certificationField = PiCKTextField(
        titleText: "인증 코드",
        placeholder: "인증 코드를 입력해주세요",
        buttonIsHidden: true
    )
    private let nextButton = PiCKButton(
        buttonText: "다음",
        isHidden: false
    )

    public override func attribute() {
        super.attribute()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    public override func bind() {
        let input = VerifyEmailViewModel.Input(
            nextButtonTap: nextButton.rx.tap.asObservable(),
            emailText: emailTextField.rx.text.orEmpty.asObservable(),
            certificationText: certificationField.rx.text.orEmpty.asObservable()
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
        emailTextField,
        certificationField,
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
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(75)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        certificationField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(71)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
