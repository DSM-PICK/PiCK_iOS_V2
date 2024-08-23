import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class HomeViewController: BaseViewController<HomeViewModel> {
    private let viewModeRelay = PublishRelay<HomeViewType>()
    private let loadSchoolMealRelay = PublishRelay<String>()

    private let todayDate = Date()

    private lazy var subViewSize = CGRect(
        x: 0,
        y: 0,
        width: self.view.frame.width,
        height: 350
    )

    private lazy var homeViewType: HomeViewType = .timeTable
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainView = UIView()

    private lazy var navigationBar = PiCKMainNavigationBar(view: self, settingIsHidden: false)
    private let profileView = PiCKProfileView()

    private let todayTimeTableLabel = PiCKLabel(
        text: "오늘의 시간표",
        textColor: .gray700,
        font: .label1
    )
//    private lazy var topCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
//        $0.scrollDirection = .vertical
//        switch homeViewType {
//        case .timeTable:
//            $0.itemSize = .init(width: self.view.frame.width, height: 44)
//        case .schoolMeal:
//            $0.itemSize = .init(width: self.view.frame.width, height: 102)
//        }
//    }
//    //TODO: 시간표가 바뀌었다는 알림을 headerView로 표현?
//    private lazy var topCollectionView = UICollectionView(
//        frame: .zero,
//        collectionViewLayout: topCollectionViewFlowLayout
//    ).then {
//        $0.backgroundColor = .background
//        $0.showsHorizontalScrollIndicator = false
//        $0.showsVerticalScrollIndicator = false
//        switch homeViewType {
//        case .timeTable:
//            $0.register(
//                TimeTableCollectionViewCell.self,
//                forCellWithReuseIdentifier: TimeTableCollectionViewCell.identifier
//            )
//        case .schoolMeal:
//            $0.register(
//                SchoolMealHomeCell.self,
//                forCellWithReuseIdentifier: SchoolMealHomeCell.identifier
//            )
//        }
//    }
    //stackview에 넣어서 정리
    
    private lazy var timeTableView = HomeTimeTableView(frame: subViewSize)
    private lazy var schoolMealView = HomeSchoolMealView(frame: subViewSize)
    private lazy var stackView = UIStackView(arrangedSubviews: [
        timeTableView,
        schoolMealView
    ]).then {
        $0.axis = .vertical
    }
    private let selfStudyBannerView = PiCKHomeBannerView()
    private let recentNoticeLabel = PiCKLabel(
        text: "최신 공지",
        textColor: .gray700,
        font: .label1
    )
    private let viewMoreButton = UIButton(type: .system).then {
        $0.setTitle("더보기", for: .normal)
        $0.setTitleColor(.gray800, for: .normal)
        $0.titleLabel?.font = .label1
    }
    private lazy var noticeStackView = UIStackView(arrangedSubviews: [
        recentNoticeLabel,
        viewMoreButton
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private lazy var noticeCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.view.frame.width, height: 81)
    }
    private lazy var noticeCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: noticeCollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.register(
            NoticeCollectionViewCell.self,
            forCellWithReuseIdentifier: NoticeCollectionViewCell.identifier
        )
    }

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()
        
        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = HomeViewModel.Input(
            viewWillApper: viewWillAppearRelay.asObservable(),
            clickAlert: navigationBar.alertButtonTap.asObservable(),
            clickViewMoreNotice: viewMoreButton.rx.tap.asObservable(),
            todayDate: todayDate.toString(type: .fullDate)
        )
        let output = viewModel.transform(input: input)

        output.viewMode.asObservable()
            .bind(onNext: { [weak self] data in
                self?.homeViewType = data
                switch self?.homeViewType {
                case .timeTable:
                    self?.schoolMealView.isHidden = true
                    self?.timeTableView.isHidden = false
                    self?.loadViewIfNeeded()
                    
//                    self?.setLayout()
                case .schoolMeal:
                    self?.timeTableView.isHidden = true
                    self?.schoolMealView.isHidden = false
//                    self?.setLayout()
                    self?.loadViewIfNeeded()
                case .none:
                    return
                }
            }).disposed(by: disposeBag)

        output.timetableData.asObservable()
            .bind(onNext: { [weak self] data in
                self?.timeTableView.setup(timeTableData: data)
            }).disposed(by: disposeBag)

        output.schoolMealData.asObservable()
            .bind(onNext: { [weak self] data in
                self?.schoolMealView.setup(schoolMealData: data)
            }).disposed(by: disposeBag)

        output.noticeListData.asObservable()
            .bind(to: noticeCollectionView.rx.items(
                cellIdentifier: NoticeCollectionViewCell.identifier,
                cellType: NoticeCollectionViewCell.self
            )) { row, item, cell in
                cell.adapt(model: item)
            }.disposed(by: disposeBag)

        output.selfStudyData.asObservable()
            .bind(onNext: { [weak self] data in
                self?.selfStudyBannerView.setup(selfStudyTeacherData: data)
            }).disposed(by: disposeBag)
    }

    public override func addView() {
        [
            navigationBar,
            profileView,
            scrollView
        ].forEach { view.addSubview($0) }

        scrollView.addSubview(contentView)
        contentView.addSubview(mainView)

       [
            todayTimeTableLabel,
            stackView,
            selfStudyBannerView,
            noticeStackView,
            noticeCollectionView,
       ].forEach { mainView.addSubview($0) }
    }
    
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        profileView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.view.frame.height * 1.6)
        }

        todayTimeTableLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(todayTimeTableLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)//TODO: 높이 조절 필요
        }
        selfStudyBannerView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(160)
        }
        noticeStackView.snp.makeConstraints {
            $0.top.equalTo(selfStudyBannerView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        noticeCollectionView.snp.makeConstraints {
            $0.top.equalTo(recentNoticeLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(350)//TODO: 높이 조절 필요
        }
    }

}
