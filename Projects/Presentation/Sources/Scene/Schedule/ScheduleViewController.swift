import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ScheduleViewController: BaseViewController<ScheduleViewModel> {
    private lazy var navigationBar = PiCKMainNavigationBar(view: self)

//    private let scheduleSegmentedControl = PiCKSegmentedControl(items: [])

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func addView() {
        [
            navigationBar
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }

}
