import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import DesignSystem

public class MyPageViewController: BaseViewController<MyPageViewModel> {
    private let profileImageView = UIImageView(image: .profile)
    private let changeButton = UIButton(type: .system).then {
        $0.setTitle("변경하기", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        $0.titleLabel?.font = .body1
    }

    private let nameLabel = MyPageLabel(type: .contentTitleLabel, text: "이름")
    private let birthDateLabel = MyPageLabel(type: .contentTitleLabel, text: "생년월일")
    private let studentIDLabel = MyPageLabel(type: .contentTitleLabel, text: "학번")
    private let idLabel = MyPageLabel(type: .contentTitleLabel, text: "아이디")
    private lazy var userInfoLabelStackView = UIStackView(arrangedSubviews: [
        nameLabel,
        birthDateLabel,
        studentIDLabel,
        idLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.distribution = .fillEqually
    }

    private let userNameLabel = MyPageLabel(type: .contentLabel)
    private let userBirthDateLabel = MyPageLabel(type: .contentLabel)
    private let userStudentIDLabel = MyPageLabel(type: .contentLabel)
    private let userIDLabel = MyPageLabel(type: .contentLabel)
    private lazy var userInfoStackView = UIStackView(arrangedSubviews: [
        userNameLabel,
        userBirthDateLabel,
        userStudentIDLabel,
        userIDLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .trailing
        $0.distribution = .fillEqually
    }

    public override func attribute() {
        super.attribute()

        navigationTitleText = "마이 페이지"
    }
    public override func addView() {
        [
            profileImageView,
            changeButton,
            userInfoLabelStackView,
            userInfoStackView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        changeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
        }
        userInfoLabelStackView.snp.makeConstraints {
            $0.top.equalTo(changeButton.snp.bottom).offset(76)
            $0.left.equalToSuperview().inset(24)
        }
        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(changeButton.snp.bottom).offset(76)
            $0.right.equalToSuperview().inset(24)
        }
    }

}
