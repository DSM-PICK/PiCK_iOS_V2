import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class AcademicScheduleCell: BaseCollectionViewCell<Any> {
    static let identifier = "AcademicScheduleCell"

    private let lineView = UIView().then {
        $0.backgroundColor = .main500
    }
    private let scheduleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .pickFont(.subTitle2)
    )

    public func setup(schedule: String) {
        self.scheduleLabel.text = schedule
    }

    public override func attribute() {
        self.backgroundColor = .background
    }
    public override func layout() {
        [
            lineView,
            scheduleLabel
        ].forEach { self.addSubview($0) }

        lineView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(3)
        }
        scheduleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(lineView.snp.trailing).offset(21)
        }
    }

}
