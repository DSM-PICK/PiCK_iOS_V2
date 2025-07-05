import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core
import DesignSystem

final public class InfoSettingViewController: BaseViewController<InfoSettingViewModel> {
    private let titleLabel = PiCKLabel(
        text: "PiCK에 회원가입하기",
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    ).then {
        $0.changePointColor(targetString: "PiCK", color: .main500)
    }
    private let explainLabel = PiCKLabel(
        text: "학번과 이름을 입력해주세요.",
        textColor: .gray600,
        font: .pickFont(.body1)
    )
    private let startTimeSelectButton = TimeSelectButton(type: .system)
    private let sinceLabel = PiCKLabel(
        text: "부터",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let endTimeSelectButton = TimeSelectButton(type: .system)
    private let untilLabel = PiCKLabel(
        text: "까지",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let periodSelectButton = TimeSelectButton(type: .system)
    private lazy var outingTimeStackView = UIStackView(arrangedSubviews: [
        startTimeSelectButton,
        sinceLabel,
        endTimeSelectButton,
        untilLabel,
        periodSelectButton
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 12
    }
    private let nextButton = PiCKButton(
        buttonText: "다음",
        isHidden: false
    )

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            outingTimeStackView,
            nextButton
        ].forEach { view.addSubview($0) }
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        outingTimeStackView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

}
