import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ScheduleViewController: BaseViewController<ScheduleViewModel> {
    private lazy var navigationBar = PiCKMainNavigationBar(view: self)

    private let scheduleSegmentedControl = ScheduleSegmentedControl(items: ["시간표", "학사일정"])
    private let timeTableView = TimeTableView()

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func addView() {
        [
            navigationBar,
            scheduleSegmentedControl,
            timeTableView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        scheduleSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(46)
        }
        timeTableView.snp.makeConstraints {
            $0.top.equalTo(scheduleSegmentedControl.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
    }

}
