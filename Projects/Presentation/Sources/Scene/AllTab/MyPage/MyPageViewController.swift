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

    private lazy var userInfoLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.distribution = .fillEqually
    }

    private lazy var userInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.alignment = .trailing
        $0.distribution = .fillEqually
    }

    public override func attribute() {
        super.attribute()

        navigationTitleText = "마이 페이지"
        setupMyPageLabel()
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

    private func setupMyPageLabel() {
        let titleArray = ["이름", "생년월일", "학번", "아이디"]
        for title in titleArray {
            let titleLabel = AllTabLabel(
                type: .contentTitleLabel,
                text: title
            )
            userInfoLabelStackView.addArrangedSubview(titleLabel)
        }
        
        let userInfoArry = ["조영준", "2007.05.13", "2413", "cyj513"]
        for userInfo in userInfoArry {
            let userInfoLabel = AllTabLabel(
                type: .contentLabel,
                text: userInfo
            )
            userInfoStackView.addArrangedSubview(userInfoLabel)
        }
    }

}
