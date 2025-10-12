import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class InfoCheckView: UIViewController {
    private let disposeBag = DisposeBag()
    public var actionOnTap: () -> Void

    private let backgroundView = UIView().then {
        $0.backgroundColor = .background
        $0.layer.cornerRadius = 15
    }

    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.subTitle1)
    ).then {
        $0.text = "정보 확인"
        $0.textAlignment = .center
    }

    private let nameLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.heading3)
    ).then {
        $0.textAlignment = .center
    }

    private let descriptionLabel = PiCKLabel(
        textColor: .gray600,
        font: .pickFont(.subTitle3),
        numberOfLines: 0
    ).then {
        $0.text = "잘못된 정보 입력 시,\n픽에서 책임지지 않습니다."
        $0.textAlignment = .center
    }

    private let confirmButton = UIButton().then {
        $0.setTitle("네, 맞습니다", for: .normal)
        $0.setTitleColor(.modeWhite, for: .normal)
        $0.titleLabel?.font = .pickFont(.button1)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .main500
    }

    public init(
        grade: String,
        classNumber: String,
        number: String,
        name: String,
        actionOnTap: @escaping () -> Void
    ) {
        self.nameLabel.text = "\(grade)학년 \(classNumber)반 \(number)번 \(name)"
        self.actionOnTap = actionOnTap
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        bindActions()
        addView()
        setLayout()
    }

    private func bindActions() {
        confirmButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true) {
                    self?.actionOnTap()
                }
            }
            .disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .bind { [weak self] gesture in
                let location = gesture.location(in: self?.view)
                if !(self?.backgroundView.frame.contains(location) ?? false) {
                    self?.dismiss(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }

    private func addView() {
        view.addSubview(backgroundView)
        [
            titleLabel,
            nameLabel,
            descriptionLabel,
            confirmButton
        ].forEach { backgroundView.addSubview($0) }
    }

    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(55)
            $0.height.equalTo(296)
        }

        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(24)
        }

        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
        }

        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(42)
        }

        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(41)
        }
    }
}
