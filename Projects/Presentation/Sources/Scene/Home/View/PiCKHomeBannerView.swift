import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class PiCKHomeBannerView: BaseView {
    private let bannerBackgroundImageView = UIImageView(image: .mainBanner)

    private let explainLabel = PiCKLabel(
        text: "오늘의 자습 감독 선생님 입니다",
        textColor: .gray900,
        font: .label2
    ).then {
        $0.changePointFont(targetString: "자습 감독", font: .button2)
    }
    private lazy var floorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    private lazy var teacherStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }

    public func setup(
        selfStudyTeacherData: SelfStudyEntity
    ) {
        setupBannerLabel(data: selfStudyTeacherData)
    }

    public override func attribute() {
        super.attribute()

        self.layer.cornerRadius = 12
    }

    public override func layout() {
        [
            bannerBackgroundImageView,
            explainLabel,
            floorStackView,
            teacherStackView
        ].forEach { self.addSubview($0) }
        
        bannerBackgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27.5)
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
    }

    private func setupBannerLabel(data: SelfStudyEntity) {
        floorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for floor in data {
            let floorLabel = PiCKLabel(
                text: "\(floor.floor)층",
                textColor: .main900,
                font: .label2, 
                alignment: .center
            )
            floorStackView.addArrangedSubview(floorLabel)
        }

        teacherStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for teacher in data {
            let teacherLabel = PiCKLabel(
                text: "\(teacher.teacherName) 선생님",
                textColor: .modeBlack,
                font: .subTitle3
            )
            teacherStackView.addArrangedSubview(teacherLabel)
        }
    }

}
