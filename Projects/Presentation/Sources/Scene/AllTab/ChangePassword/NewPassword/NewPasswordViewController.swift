import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core
import DesignSystem

public class NewPasswordViewController: BaseViewController<NewPasswordViewModel> {
    public var code: String = ""
    public var accountId: String = ""

    private let titleLabel = PiCKLabel(
        text: "PiCK 비밀번호 변경하기",
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    ).then {
        $0.changePointColor(targetString: "PiCK", color: .main500)
    }
    private let explainLabel = PiCKLabel(
        text: "새로운 비밀번호를 입력해주세요.",
        textColor: .gray600,
        font: .pickFont(.body1)
    )
    private let newPasswordTextField = PiCKTextField(
        titleText: "새로운 비밀번호",
        placeholder: "비밀번호를 입력해주세요",
        buttonIsHidden: true
    ).then {
        $0.isSecurity = true
    }
    private let newPWCheckTextField = PiCKTextField(
        titleText: "새로운 비밀번호 확인",
        placeholder: "비밀번호를 입력해주세요",
        buttonIsHidden: true
    ).then {
        $0.isSecurity = true
    }
    private let changeButton = PiCKButton(
        buttonText: "변경",
        isHidden: false
    )

    public override func attribute() {
        super.attribute()

        navigationTitleText = "비밀번호 변경"
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    public override func bind() {
        let input = NewPasswordViewModel.Input(
            nextButtonTap: changeButton.rx.tap.asObservable(),
            newPasswordText: newPasswordTextField.rx.text.orEmpty.asObservable(),
            newPasswordCheckText: newPWCheckTextField.rx.text.orEmpty.asObservable(),
            accountIdText: Observable.just(self.accountId),
            codeText: Observable.just(self.code)
        )

        let output = viewModel.transform(input: input)

        output.isNextButtonEnabled
            .bind(to: changeButton.rx.isEnabled)
            .disposed(by: disposeBag)

        output.errorToastMessage
            .filter { !$0.isEmpty }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { owner, errorMessage in
                owner.presentErrorToast(message: errorMessage)
            }
            .disposed(by: disposeBag)
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            newPasswordTextField,
            newPWCheckTextField,
            changeButton
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
        newPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(75)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        newPWCheckTextField.snp.makeConstraints {
            $0.top.equalTo(newPasswordTextField.snp.bottom).offset(71)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        changeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
