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
    private let alertLabel = PiCKLabel(textColor: .modeBlack, font: .body1)

    public init(
        successType: SuccessType,
        alertType: DisappearAlertType
    ){
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
                    withTimeInterval: 1.5,
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
            $0.bottom.equalToSuperview().inset(126)
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
        switch successType {
        case .success:
            self.imageView.image = .checkIcon
            self.imageView.tintColor = .main500
            switch alertType {
            case .weekendMeal:
                self.alertLabel.text = "주말 급식 신청이 완료되었습니다!"
            case .classRoom:
                self.alertLabel.text = "교실 이동 신청이 완료되었습니다!"
            case .outing:
                self.alertLabel.text = "외출 신청이 완료되었습니다!"
            case .earlyLeave:
                self.alertLabel.text = "조기 귀가 신청이 완료되었습니다!"
            case .bug:
                self.alertLabel.text = "버그 제보가 완료되었습니다!"
                
            }
        case .fail:
            self.imageView.image = .failIcon
            self.imageView.tintColor = .error
            switch alertType {
            case .weekendMeal:
                self.alertLabel.text = "주말 급식 신청을 실패했습니다."
            case .classRoom:
                self.alertLabel.text = "교실 이동 신청을 실패했습니다."
            case .outing:
                self.alertLabel.text = "외출 신청을 실패했습니다."
            case .earlyLeave:
                self.alertLabel.text = "조기 귀가 신청을 실패했습니다."
            case .bug:
                self.alertLabel.text = "버그 제보를 실패했습니다."
            }
        }
    }

}
