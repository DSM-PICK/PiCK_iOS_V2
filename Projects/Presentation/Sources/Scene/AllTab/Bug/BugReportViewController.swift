import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core
import DesignSystem

public class BugReportViewController: BaseViewController<BugReportViewModel> {
    private let bugLocationView = BugReportView(type: .location)
    private let bugExplainView = BugReportView(type: .explain)
    private let bugImageView = BugReportView(type: .photo)
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: 100, height: 100)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.register(
            BugImageCollectionViewCell.self,
            forCellWithReuseIdentifier: BugImageCollectionViewCell.identifier
        )
        $0.delegate = self
        $0.dataSource = self
    }
    private let reportButton = PiCKButton(type: .system, buttonText: "제보하기")

    public override func attribute() {
        super.attribute()

        navigationTitleText = "버그 제보"
    }
//    public override func bindAction() {
//        super.bindAction()
//
//        bugImageView.rx.tapGesture()
//            .when(.recognized)
//            .bind(onNext: { [weak self] in
//                
//            }).disposed(by: disposeBag)
//    }
    public override func addView() {
        [
            bugLocationView,
            bugExplainView,
            bugImageView,
            collectionView,
            reportButton
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
        bugImageView.snp.makeConstraints {
            $0.top.equalTo(bugExplainView.snp.bottom).offset(40)
//            $0.leading.trailing.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(200)
            $0.height.equalTo(135)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(bugExplainView.snp.bottom).offset(75)
            $0.leading.equalTo(bugImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(100)
        }
        reportButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(60)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }

}

extension BugReportViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BugImageCollectionViewCell.identifier,
            for: indexPath) as? BugImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }

}
