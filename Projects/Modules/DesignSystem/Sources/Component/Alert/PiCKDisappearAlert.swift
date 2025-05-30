import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKDisappearAlert: UIViewController {
    private let disposeBag = DisposeBag()

    private let backgroundView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 24
    }
    private let imageView = UIImageView()
    private let alertLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.body1)
    )

    public init(
        successType: SuccessType,
        alertType: DisappearAlertType
    ) {
        super.init(nibName: nil, bundle: nil)

        self.textSetting(successType: successType, alertType: alertType)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        bind()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }

    private func bind() {
        self.rxVisible
            .subscribe(onNext: {_ in
                Timer.scheduledTimer(
                    withTimeInterval: 1,
                    repeats: false,
                    block: { _ in
                        self.dismiss(animated: true, completion: nil)
                    })
            }).disposed(by: disposeBag)
    }
    private func layout() {
        view.addSubview(backgroundView)

        [
            imageView,
            alertLabel
        ].forEach { backgroundView.addSubview($0) }

        backgroundView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(86)
            $0.height.equalTo(48)
        }
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        alertLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(imageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    private func textSetting(
        successType: SuccessType,
        alertType: DisappearAlertType
    ) {
        setupImageView(for: successType)
        alertLabel.text = createAlertMessage(successType: successType, alertType: alertType)
    }

    private func setupImageView(for successType: SuccessType) {
        switch successType {
        case .success, .already:
            imageView.image = .checkIcon
            imageView.tintColor = .main500
        case .fail:
            imageView.image = .failIcon
            imageView.tintColor = .error
        }
    }

    private struct AlertAction {
        let text: String
        let subjectParticle: String
        let objectParticle: String

        static func create(_ text: String, hasFinalConsonant: Bool) -> AlertAction {
            return AlertAction(
                text: text,
                subjectParticle: hasFinalConsonant ? "이" : "가",
                objectParticle: hasFinalConsonant ? "을" : "를"
            )
        }
    }

    private func createAlertMessage(
        successType: SuccessType,
        alertType: DisappearAlertType
    ) -> String {
        let action: AlertAction

        switch alertType {
        case .complete:
            return successType == .fail ? "실패했습니다." : "완료되었습니다!"

        case .weekendMeal:
            action = .create("주말 급식 신청", hasFinalConsonant: true)
        case .weekendMealCancel:
            action = .create("주말 급식 신청 취소", hasFinalConsonant: false)
        case .classroom:
            action = .create("교실 이동 신청", hasFinalConsonant: true)
        case .outing:
            action = .create("외출 신청", hasFinalConsonant: true)
        case .earlyLeave:
            action = .create("조기 귀가 신청", hasFinalConsonant: true)
        case .bug:
            action = .create("버그 제보", hasFinalConsonant: false)
        }

        switch successType {
        case .success:
            return "\(action.text)\(action.subjectParticle) 완료되었습니다!"
        case .fail:
            return "\(action.text)\(action.objectParticle) 실패했습니다."
        case .already:
            return "이미 \(action.text)\(action.subjectParticle) 완료되었습니다."
        }
    }
}
