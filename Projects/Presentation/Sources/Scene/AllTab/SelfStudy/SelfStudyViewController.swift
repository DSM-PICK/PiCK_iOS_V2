import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class SelfStudyViewController: BaseViewController<SelfStudyViewModel> {
    private let titleLabel = PiCKLabel(
        text: "4월 13일,\n오늘의 자습 감독 선생님입니다",
        textColor: .modeBlack,
        font: .heading4,
        numberOfLines: 0
    ).then{
        $0.changePointColor(targetString: "오늘의 자습 감독", color: .main500)
    }

    private lazy var floorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.distribution = .fillEqually
    }
    private lazy var teacherStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.distribution = .fillEqually
    }

    public override func attribute() {
        super.attribute()
        setupSelftStudyLabel()

        navigationTitleText = "자습 감독 선생님 확인"
    }

    public override func addView() {
        [
            titleLabel,
            floorStackView,
            teacherStackView
        ].forEach { view.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(52)
            $0.leading.equalToSuperview().inset(24)
        }
        floorStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        teacherStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.trailing.equalToSuperview().inset(24)
        }
    }

    private func setupSelftStudyLabel() {
        let floorArray = ["2층", "3층", "4층"]
        for floor in floorArray {
            let floorLabel = AllTabLabel(
                type: .contentTitleLabel,
                text: floor
            )
            floorStackView.addArrangedSubview(floorLabel)
        }
        
        let teacherArray = ["조영준 선생님", "박현아 선생님", "육기준 선생님"]
        for teacher in teacherArray {
            let teacherLabel = AllTabLabel(
                type: .contentLabel,
                text: teacher
            )
            teacherStackView.addArrangedSubview(teacherLabel)
        }
    }

}
