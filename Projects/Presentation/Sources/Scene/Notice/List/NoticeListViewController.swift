import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class NoticeListViewController: BaseViewController<NoticeListViewModel> {
    private let clickNoticeCellRelay = PublishRelay<UUID>()

    private let bannerView = UIImageView(image: .noticeBanner)
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.view.frame.width, height: 81)
    }
    private lazy var noticeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsHorizontalScrollIndicator = false
        $0.register(
            NoticeCollectionViewCell.self,
            forCellWithReuseIdentifier: NoticeCollectionViewCell.identifier
        )
    }
    public override func attribute() {
        super.attribute()
        navigationTitleText = "공지사항"
    }
    public override func bind() {
        let input = NoticeListViewModel.Input(
            viewWillAppear: viewWillAppearRelay.asObservable(),
            clickNoticeCell: clickNoticeCellRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.noticeListData.asObservable()
            .bind(to: noticeCollectionView.rx.items(
                cellIdentifier: NoticeCollectionViewCell.identifier,
                cellType: NoticeCollectionViewCell.self
            )) { row, item, cell in
                cell.adapt(model: item)
            }.disposed(by: disposeBag)

        noticeCollectionView.rx.modelSelected(NoticeListEntityElement.self)
            .subscribe(
                onNext: { [weak self] data in
                    self?.clickNoticeCellRelay.accept(data.id)
                    print("cjlk")
                }
            )
            .disposed(by: disposeBag)
    }
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
            $0.height.equalTo(116)
        }
        noticeCollectionView.snp.makeConstraints {
            $0.top.equalTo(bannerView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}
