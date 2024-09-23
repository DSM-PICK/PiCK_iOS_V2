import UIKit

import RxSwift
import RxCocoa

import Core

public typealias SectionModel = (title: String, icon: UIImage, tintColor: UIColor)

public class PiCKSectionView: BaseView {

    private var items: [SectionModel] = []

    private var titleLabel = PiCKLabel(
        textColor: .gray600,
        font: .label1
    )
    private let sectionTableView = UITableView().then {
        $0.backgroundColor = .background
        $0.rowHeight = 60
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.register(
            SectionTableViewCell.self,
            forCellReuseIdentifier: SectionTableViewCell.identifier
        )
    }

    public init(menuText: String, items: [SectionModel]) {
        super.init(frame: .zero)

        self.titleLabel.text = menuText
        self.items = items
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func attribute() {
        self.sectionTableView.dataSource = self
    }
    public override func layout() {
        [
            titleLabel,
            sectionTableView
        ].forEach { self.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        sectionTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(60 * items.count)
        }
    }

    public func getSelectedItem(index: Int) -> Observable<IndexPath> {
        sectionTableView.rx.itemSelected.filter { $0.row == index }
    }

}

extension PiCKSectionView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SectionTableViewCell.identifier,
            for: indexPath
        ) as? SectionTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(model: items[indexPath.row])

        return cell
    }

}
