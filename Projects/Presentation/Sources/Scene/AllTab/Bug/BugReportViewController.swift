import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class BugReportViewController: BaseViewController<BugReportViewModel> {

    private let bugLocationView = BugReportView(type: .location)
    private let bugExplainView = BugReportView(type: .explain)
    
    public override func attribute() {
        super.attribute()

        navigationTitleText = "버그 제보"
    }
    public override func addView() {
        [
            bugLocationView,
            bugExplainView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        bugLocationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(71)
        }
        bugExplainView.snp.makeConstraints {
            $0.top.equalTo(bugLocationView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(151)
        }
    }

}
