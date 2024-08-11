import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class TimeTableView: BaseView {
    
//    private lazy var timeTableData = BehaviorRelay<WeekTimeTableEntity>(value: [.init(date: "fjdksl", timetables: [.init(id: UUID(), period: 1, subjectName: "fjdksl")])])
    
    private var date = String()
    
    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.itemSize = .init(width: self.frame.width, height: self.frame.height)
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
        $0.delegate = self
        $0.dataSource = self
    }
    private lazy var pageControl = PiCKPageControl().then {
        $0.numberOfPages = 5
        $0.currentPage = 0
        $0.backgroundColor = .white
        $0.currentPageIndicatorTintColor = .main500
        $0.pageIndicatorTintColor = .gray100
        $0.allowsContinuousInteraction = false
        $0.isEnabled = false
        $0.dotRadius = 4
        $0.dotSpacings = 4
    }
    
//    public func dateSetup(
//        date: String
//    ) {
//        self.date = date
//    }
//    public func timeTableSetup(
//        timeTableData: WeekTimeTableEntity
//    ) {
//        self.timeTableData.accept(timeTableData)
//    }

    public override func bind() {
//        timeTableData.asObservable()
//            .bind(to: collectionView.rx.items(
//                cellIdentifier: TimeTableBackgroundViewCell.identifier,
//                cellType: TimeTableBackgroundViewCell.self
//            )) { row, element, cell in
//                cell.setup(
//                    date: "fjdskl",
//                    timeTableData: element.timetables
//                )
//            }
//            .disposed(by: disposeBag)
        
        collectionView.rx.didScroll
            .bind { [weak self] _ in
                guard let collectionView = self?.collectionView else { return }
                self?.pageControl.scrollViewDidScroll(collectionView)
            }
            .disposed(by: disposeBag)
    }
    public override func layout() {
        [
            collectionView,
            pageControl
        ].forEach { self.addSubview($0) }

        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(155)
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}

extension TimeTableView: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeTableBackgroundViewCell.identifier, for: indexPath) as? TimeTableBackgroundViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }

}
