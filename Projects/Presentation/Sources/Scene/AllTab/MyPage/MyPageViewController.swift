import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class MyPageViewController: BaseViewController<MyPageViewModel> {
    private let setCustomProfileRelay = PublishRelay<Void>()

    private var profileImageData = PublishRelay<Data>()

    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    private let changeButton = UIButton(type: .system).then {
        $0.setTitle("변경하기", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        $0.titleLabel?.font = .pickFont(.body1)
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
        setupProfile()
    }
    public override func bind() {
        let input = MyPageViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            profileImage: profileImageData.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.profileData.asObservable()
            .withUnretained(self)
            .bind { owner, profileData in
                owner.profileImageView.setImage(with: profileData.profile ?? "")
                owner.userNameLabel.text = profileData.name
                owner.userBirthDayLabel.text = "\(profileData.birthDay.toDate(type: .fullDate).toString(type: .fullDateKorForCalendar))"
                owner.userSchoolIDLabel.text = "\(profileData.grade)학년 \(profileData.classNum)반 \(profileData.num)번"
                owner.userIDLabel.text = profileData.accountID
            }.disposed(by: disposeBag)
    }
    public override func bindAction() {
        setCustomProfileRelay.bind { [weak self] in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }.disposed(by: disposeBag)
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.size.equalTo(80)
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

    private func setupProfile() {
        changeButton.menu = UIMenu(title: "프로필 이미지 설정", children: [
            UIAction(title: "사진 선택하기", handler: { _ in
                self.setCustomProfileRelay.accept(())
            }),
            UIAction(title: "기본 이미지로 설정하기", handler: { _ in
                self.profileImageView.image = .profile
                self.profileImageData.accept(UIImage.profile.jpegData(compressionQuality: 0.1) ?? Data())
            })
        ])
        changeButton.showsMenuAsPrimaryAction = true
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

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true) { [weak self] in
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self?.profileImageView.image = image
            self?.profileImageData.accept(image?.jpegData(compressionQuality: 0.1) ?? Data())
        }
    }
}
