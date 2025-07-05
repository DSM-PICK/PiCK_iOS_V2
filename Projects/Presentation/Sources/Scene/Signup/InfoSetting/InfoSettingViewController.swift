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
    private let numberTitleLabel = PiCKLabel(
        text: "학번",
        textColor: .black,
        font: .pickFont(.label1)
    )
    private let selectButton = SchoolNumberSelectButton(type: .system)
    private let gradeLabel = PiCKLabel(
        text: "학년",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let classSelectButton = SchoolNumberSelectButton(type: .system)
    private let classNumberLabel = PiCKLabel(
        text: "반",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let numberSelectButton = SchoolNumberSelectButton(type: .system)
    private let schoolNumberLabel = PiCKLabel(
        text: "번",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private lazy var studentNumberStackView = UIStackView(arrangedSubviews: [
        selectButton,
        gradeLabel,
        classSelectButton,
        classNumberLabel,
        numberSelectButton,
        schoolNumberLabel
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    private let nextButton = PiCKButton(
        buttonText: "다음",
        isHidden: false
    )

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            numberTitleLabel,
            studentNumberStackView,
            nextButton
        ].forEach { view.addSubview($0) }
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
        numberTitleLabel.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(46.5)
            $0.leading.equalToSuperview().inset(24)
        }
        studentNumberStackView.snp.makeConstraints {
            $0.top.equalTo(numberTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }

}
