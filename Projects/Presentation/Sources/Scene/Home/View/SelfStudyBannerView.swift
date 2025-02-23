import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class SelfStudyBannerView: BaseView {
    private let explainLabel = PiCKLabel(
        text: "오늘의 자습 감독 선생님 입니다",
        textColor: .gray900,
        font: .pickFont(.label2)
    ).then {
        $0.changePointFont(targetString: "자습 감독", font: .pickFont(.button2))
    }
    private let emptySelfStudyLabel = PiCKLabel(
        text: "오늘은\n자습감독 선생님이 없습니다",
        textColor: .modeBlack,
        font: .pickFont(.label2)
    )
    private lazy var floorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    private lazy var teacherStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    private let calendarImageVIew = UIImageView(image: .calendarIcon)

    public func setup(
        selfStudyTeacherData: SelfStudyEntity
    ) {
        if selfStudyTeacherData.isEmpty {
            self.explainLabel.isHidden = true
            self.emptySelfStudyLabel.isHidden = false
        } else {
            self.explainLabel.isHidden = false
            self.emptySelfStudyLabel.isHidden = true
            setupBannerLabel(data: selfStudyTeacherData)
        }
    }

    public override func attribute() {
        super.attribute()

        self.backgroundColor = .gray50
        self.layer.cornerRadius = 12
    }

    public override func layout() {
        [
            explainLabel,
            emptySelfStudyLabel,
            floorStackView,
            teacherStackView,
            calendarImageVIew
        ].forEach { self.addSubview($0) }

        self.snp.makeConstraints {
            $0.height.equalTo(160)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27.5)
            $0.leading.equalToSuperview().inset(22.5)
        }
        emptySelfStudyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(22.5)
        }
        floorStackView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(22.5)
            $0.height.equalTo(75)
        }
        teacherStackView.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(16)
            $0.leading.equalTo(floorStackView.snp.trailing).offset(16)
            $0.height.equalTo(75)
        }
        calendarImageVIew.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(140)
        }
    }

    private func setupBannerLabel(data: SelfStudyEntity) {
        floorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for floor in data {
            let floorLabel = PiCKLabel(
                text: "\(floor.floor)층",
                textColor: .main900,
                font: .pickFont(.label2),
                alignment: .center
            )
            floorStackView.addArrangedSubview(floorLabel)
        }

        teacherStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for teacher in data {
            let teacherLabel = PiCKLabel(
                text: "\(teacher.teacherName) 선생님",
                textColor: .modeBlack,
                font: .pickFont(.subTitle3)
            )
            teacherStackView.addArrangedSubview(teacherLabel)
        }
    }

}
