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
//        $0.setTitle("변경하기", for: .normal)
        $0.setTitle("", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        $0.titleLabel?.font = .body1
    }

    private lazy var userInfoLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.distribution = .fillEqually
    }

    private var userNameLabel = AllTabLabel(type: .contentLabel)
    private var userBirthDayLabel = AllTabLabel(type: .contentLabel)
    private var userSchoolIDLabel = AllTabLabel(type: .contentLabel)
    private var userIDLabel = AllTabLabel(type: .contentLabel)
    private lazy var userInfoStackView = UIStackView(arrangedSubviews: [
        userNameLabel,
        userBirthDayLabel,
        userSchoolIDLabel,
        userIDLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.alignment = .trailing
        $0.distribution = .fillEqually
    }

    public override func attribute() {
        super.attribute()

        navigationTitleText = "마이페이지"
        setupMyPageLabel()
    }
    public override func bind() {
        let input = MyPageViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.profileData.asObservable()
            .bind(onNext: { [weak self] profileData in
                self?.userNameLabel.text = profileData.name
                self?.userBirthDayLabel.text = "\(profileData.birthDay.toDate(type: .fullDate).toString(type: .fullDateKorForCalendar))"
                self?.userSchoolIDLabel.text = "\(profileData.grade)학년 \(profileData.classNum)반 \(profileData.num)번"
                self?.userIDLabel.text = profileData.accountID
            }).disposed(by: disposeBag)
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
            $0.leading.equalToSuperview().inset(24)
        }
        userInfoStackView.snp.makeConstraints {
            $0.top.equalTo(changeButton.snp.bottom).offset(76)
            $0.trailing.equalToSuperview().inset(24)
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
    }

}
