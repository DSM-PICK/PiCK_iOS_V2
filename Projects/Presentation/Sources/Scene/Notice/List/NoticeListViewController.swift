import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class NoticeListViewController: BaseViewController<NoticeListViewModel> {
    
    private let noticeDetailRelay = PublishRelay<Void>()

    private let bannerView = UIImageView(image: .noticeBanner)
    private lazy var bottomCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.view.frame.width, height: 81)
    }
    private lazy var noticeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: bottomCollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(
            NoticeCollectionViewCell.self,
            forCellWithReuseIdentifier: NoticeCollectionViewCell.identifier
        )
        $0.delegate = self
        $0.dataSource = self
    }
    public override func attribute() {
        super.attribute()
        navigationTitleText = "공지사항"
    }
    let dd = BehaviorRelay<[NoticeListEntityElement]>(value: [
        NoticeListEntityElement(id: UUID(), title: "test", createAt: "fjdskl")
    ])
//    public override func bind() {
//        let input = NoticeListViewModel.Input(
//            clickNotice: noticeDetailRelay.asObservable()
//        )
//        _ = viewModel.transform(input: input)
//
//        dd.bind(to: noticeCollectionView.rx.items(
//            cellIdentifier: NoticeCollectionViewCell.identifier,
//            cellType: NoticeCollectionViewCell.self
//        )) { row, item, cell in
//            cell.setup(title: "[중요] 오리엔테이션날 일정 안내", daysAgo: "1일전", isNew: false)
//        }.disposed(by: disposeBag)
//        
//        noticeCollectionView.rx.modelSelected(NoticeListEntityElement.self)
//            .bind(onNext: { index in
//                self.noticeDetailRelay.accept(())
//                print(index)
//            }).disposed(by: disposeBag)
//    }
    public override func addView() {
        [
            bannerView,
            noticeCollectionView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        bannerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        noticeCollectionView.snp.makeConstraints {
            $0.top.equalTo(bannerView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}

extension NoticeListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: NoticeCollectionViewCell.identifier,
                for: indexPath
        ) as? NoticeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(title: "[중요] 오리엔테이션날 일정 안내", daysAgo: "1일전", isNew: false)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = collectionView.dequeueReusableCell(withReuseIdentifier: NoticeCollectionViewCell.identifier, for: indexPath)
        
//        noticeDetailRelay.accept(())
        self.navigationController?.pushViewController(NoticeDetailViewController(viewModel: NoticeDetailViewModel()), animated: true)
        
    }
    
}

public struct NoticeListEntityElement {
    public let id: UUID
    public let title: String
    public let createAt: String
    
    public init(id: UUID, title: String, createAt: String) {
        self.id = id
        self.title = title
        self.createAt = createAt
    }
}
