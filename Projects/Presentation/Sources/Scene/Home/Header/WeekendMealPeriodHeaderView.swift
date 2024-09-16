import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class WeekendMealPeriodHeaderView: BaseView {
    private let speakerIcon = UIImageView(image: .voice)
    private let announcementLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .label2
    )

    public func setup(
        startPeriodText: String?,
        endPeriodText: String?
    ) {
        self.announcementLabel.text = "지금은 주말 급식 신청 기간입니다 (\(startPeriodText ?? "")~\(endPeriodText ?? "")"

        self.announcementLabel.changePointColor(targetString: "주말 급식 신청 기간", color: .main900)
    }
    public override func attribute() {
        self.backgroundColor = .main50
        self.layer.cornerRadius = 20
    }

    public override func layout() {
        [
            speakerIcon,
            announcementLabel
        ].forEach { self.addSubview($0) }

        speakerIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        announcementLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }

}
