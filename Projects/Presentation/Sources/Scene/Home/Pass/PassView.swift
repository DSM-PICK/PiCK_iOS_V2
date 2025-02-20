import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class PassView: UIViewController {
    private let disposeBag = DisposeBag()

    private let backgroundView = UIView().then {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 15
    }
    private let titleLabel = PiCKLabel(
        text: "외출증",
        textColor: .modeBlack,
        font: .pickFont(.subTitle1)
    )

    private let nameLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    )
    private let infoLabel = PiCKLabel(
        textColor: .gray700,
        font: .pickFont(.subTitle2)
    )
    private lazy var userInfoStackView = UIStackView(arrangedSubviews: [
        nameLabel,
        infoLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 6
    }
    private let profileView = UIImageView(image: .profile)
    private let outingTimeView = PassTextContainer(title: "외출 시간")
    private let reasonView = PassTextContainer(title: "사유")
    private let aproveTeacherView = PassTextContainer(title: "확인 교사")
    private lazy var textStackView = UIStackView(arrangedSubviews: [
        outingTimeView,
        reasonView,
        aproveTeacherView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.distribution = .fillEqually
    }
    private let logoImageView = UIImageView(image: .PiCKLogo)

    public func setup(
        name: String,
        info: String,
        time: String,
        reason: String,
        teacher: String
    ) {
        self.nameLabel.text = name
        self.infoLabel.text = info
        self.outingTimeView.setup(content: time)
        self.reasonView.setup(content: reason)
        self.aproveTeacherView.setup(content: teacher)
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .placeholderText
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        addView()
        setLayout()
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }

    private func addView() {
        view.addSubview(backgroundView)
        [
            titleLabel,
            userInfoStackView,
            profileView,
            textStackView,
            logoImageView
        ].forEach { backgroundView.addSubview($0) }
    }
    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(self.view.frame.height * 0.54)
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
        }
        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(23)
            $0.leading.equalToSuperview().inset(24)
        }
        profileView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(23)
            $0.trailing.equalToSuperview().inset(24)
        }
        textStackView.snp.makeConstraints {
            $0.top.equalTo(userInfoStackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(91)
        }
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
            $0.width.equalTo(60)
            $0.height.equalTo(22)
        }
    }

}
