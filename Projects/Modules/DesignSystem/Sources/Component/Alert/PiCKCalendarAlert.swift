import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKCalendarAlert: UIViewController {
    private let calendarView = PiCKCalendarView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layout()
    }

    private func layout() {
        view.addSubview(calendarView)

        calendarView.snp.makeConstraints {
            $0.height.equalTo(390)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}
