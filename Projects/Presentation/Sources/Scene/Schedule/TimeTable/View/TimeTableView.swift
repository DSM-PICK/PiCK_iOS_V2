import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class TimeTableView: BaseView {
    private lazy var timeTableData = BehaviorRelay<WeekTimeTableEntity>(value: [])

    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.itemSize = .init(
            width: self.frame.width,
            height: self.frame.height
        )
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.bounces = false
        $0.register(
            TimeTableBackgroundViewCell.self,
            forCellWithReuseIdentifier: TimeTableBackgroundViewCell.identifier
        )
    }
    private lazy var pageControl = PiCKPageControl().then {
        $0.numberOfPages = 5
        $0.currentPage = 0
        $0.backgroundColor = .background
        $0.currentPageIndicatorTintColor = .main500
        $0.pageIndicatorTintColor = .gray100
        $0.allowsContinuousInteraction = false
        $0.isEnabled = false
        $0.dotRadius = 4
        $0.dotSpacings = 4
    }

    public func timeTableSetup(
        timeTableData: WeekTimeTableEntity
    ) {
        self.timeTableData.accept(timeTableData)

        let today = Calendar.current.startOfDay(for: Date())

        if let todayIndex = timeTableData.firstIndex(where: { timetable in
            Calendar.current.isDate(
                timetable.date.toDate(type: .fullDate),
                inSameDayAs: today
            )
        }) {
            let indexPath = IndexPath(item: todayIndex, section: 0)
            collectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: false
            )

            pageControl.currentPage = todayIndex
        }
    }

    public override func bind() {
        timeTableData.asObservable()
            .bind(to: collectionView.rx.items(
                cellIdentifier: TimeTableBackgroundViewCell.identifier,
                cellType: TimeTableBackgroundViewCell.self
            )) { _, item, cell in
                cell.adapt(model: item)
            }.disposed(by: disposeBag)

        collectionView.rx.didScroll
            .withUnretained(self)
            .bind { owner, _ in
                owner.pageControl.scrollViewDidScroll(owner.collectionView)
            }.disposed(by: disposeBag)
    }
    public override func layout() {
        [
            collectionView,
            pageControl
        ].forEach { self.addSubview($0) }

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(5)
        }
    }

}
