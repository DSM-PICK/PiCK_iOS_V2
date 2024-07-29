import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class AlertViewController: BaseViewController<AlertViewModel> {

    private let newAlertLabel = PiCKLabel(text: "읽지 않은 알림 (0)", textColor: .modeBlack, font: .subTitle2)
    private let readAllButton = UIButton(type: .system).then {
        $0.setTitle("모두 읽음", for: .normal)
        $0.setTitleColor(.main500, for: .normal)
        $0.titleLabel?.font = .subTitle2
    }
    private lazy var alertStackView = UIStackView(arrangedSubviews: [
        newAlertLabel,
        readAllButton
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private lazy var alertTableView = UITableView().then {
        $0.backgroundColor = .background
        $0.rowHeight = 71
        $0.separatorStyle = .none
        $0.register(
            AlertTableViewCell.self,
            forCellReuseIdentifier: AlertTableViewCell.identifier
        )
        $0.delegate = self
        $0.dataSource = self
    }

    public override func addView() {
        [
            alertStackView,
            alertTableView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        alertStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        alertTableView.snp.makeConstraints {
            $0.top.equalTo(alertStackView.snp.bottom).offset(18)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}

extension AlertViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.identifier, for: indexPath) as? AlertTableViewCell 
        else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.setup(title: "test", daysAgo: "5")
        return cell
    }
    
}
