import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class WeekendMealPeriodHeaderView: BaseView {
    private let backgroundView = UIView().then {
        $0.backgroundColor = .main50
        $0.layer.cornerRadius = 20
    }

    private let speakerIcon = UIImageView(image: .voice).then {
        $0.tintColor = .modeBlack
    }
    private let announcementLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label2,
        alignment: .center
    )

    public func setup(
        period: String
    ) {
        self.announcementLabel.text = "지금은 주말 급식 신청 기간입니다 \(period)"
        self.announcementLabel.changePointColor(targetString: "주말 급식 신청 기간", color: .main900)
    }

    public override func layout() {
        self.addSubview(backgroundView)

        [
            speakerIcon,
            announcementLabel
        ].forEach { backgroundView.addSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(42)
        }
        backgroundView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(42)
        }

        speakerIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(18)
        }
        announcementLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(speakerIcon.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

}
