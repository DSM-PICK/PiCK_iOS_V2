import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Starscream

import Core
import Domain
import DesignSystem

public class HomeViewController: BaseViewController<HomeViewModel> {
    private var homeViewType: HomeViewType = .timeTable

    private var clickNoticeRelay = PublishRelay<UUID>()

    private let todayDate = Date()

    private lazy var subViewSize = CGRect(
        x: 0,
        y: 0,
        width: self.view.frame.width,
        height: 0
    )
    private lazy var timeTableHeight = BehaviorRelay<CGFloat>(value: 0)
    private lazy var schoolMealHeight = BehaviorRelay<CGFloat>(value: 0)

    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    private let contentView = UIView()
    private let mainView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.layoutMargins = .init(
            top: 0,
            left: 0,
            bottom: 16,
            right: 0
        )
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private lazy var navigationBar = PiCKMainNavigationBar(view: self)

    private let weekendMealPeriodHeaderView = WeekendMealPeriodHeaderView()
    private lazy var profileView = PiCKProfileView()
    private let passHeaderView = HomePassHeaderView().then {
        $0.isHidden = true
    }

    private lazy var headerStackView = UIStackView(arrangedSubviews: [
        weekendMealPeriodHeaderView,
        profileView,
        passHeaderView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
    }

    private let todaysLabel = PiCKLabel(
        textColor: .gray700,
        font: .label1
    )
    private lazy var timeTableView = HomeTimeTableView(frame: subViewSize)
    private lazy var schoolMealView = HomeSchoolMealView(frame: subViewSize)
    private lazy var mainStackView = UIStackView(arrangedSubviews: [
        todaysLabel,
        timeTableView,
        schoolMealView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    private let selfStudyBannerView = PiCKHomeSelfStudyBannerView()
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
    private lazy var noticeTitleStackView = UIStackView(arrangedSubviews: [
        recentNoticeLabel,
        viewMoreButton
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private lazy var noticeCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 5
        $0.itemSize = .init(
            width: self.view.frame.width,
            height: 81
        )
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
    private lazy var noticeStackView = UIStackView(arrangedSubviews: [
        noticeTitleStackView,
        noticeCollectionView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
    }

    public override func configureNavgationBarLayOutSubviews() {
        navigationController?.isNavigationBarHidden = true
    }

    public override func bind() {
        let input = HomeViewModel.Input(
            todayDate: todayDate.toString(type: .fullDate),
            viewWillAppear: viewWillAppearRelay.asObservable(),
            clickAlert: navigationBar.alertButtonTap.asObservable(),
            clickOutingPass: passHeaderView.buttonTap.asObservable(),
            clickViewMoreNotice: viewMoreButton.rx.tap.asObservable(),
            clickNotice: clickNoticeRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.viewMode.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.setupViewType(type: data)
                owner.homeViewType = data
            }.disposed(by: disposeBag)

        output.profileData.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                let userInfoData = UserDefaultStorage.shared.get(forKey: .userInfoData) as? String

                owner.profileView.setup(
                    image: data.profile ?? "",
                    info: userInfoData ?? ""
                )
            }.disposed(by: disposeBag)

        output.applyStatusData.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                let passIsHidden = data.type?.isEmpty
                let isWait = data.userName == .none
                owner.passHeaderView.isHidden = passIsHidden ?? true
                owner.passHeaderView.setup(
                    isWait: isWait,
                    type: OutingType(rawValue: data.type ?? "") ?? .application,
                    startTime: data.startTime,
                    endTime: data.endTime,
                    classRoomText: data.classroom
                )
                owner.loadViewIfNeeded()
            }.disposed(by: disposeBag)

        output.weekendMealPeriodData
            .asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.weekendMealPeriodHeaderView.isHidden = !data.status
                owner.weekendMealPeriodHeaderView.setup(period: data.period)
            }.disposed(by: disposeBag)

        output.timetableData
            .asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.timeTableView.setup(timeTableData: data)
            }.disposed(by: disposeBag)

        output.schoolMealData
            .asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.schoolMealView.setup(schoolMealData: data)
            }.disposed(by: disposeBag)

        output.noticeListData
            .asObservable()
            .bind(to: noticeCollectionView.rx.items(
                cellIdentifier: NoticeCollectionViewCell.identifier,
                cellType: NoticeCollectionViewCell.self
            )) { _, item, cell in
                cell.adapt(model: item)
            }.disposed(by: disposeBag)

        noticeCollectionView.rx
            .modelSelected(NoticeListEntityElement.self)
            .withUnretained(self)
            .bind { owner, data in
                owner.clickNoticeRelay.accept(data.id)
            }.disposed(by: disposeBag)

        output.outingPassData.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                let pass = PassView()
                pass.modalTransitionStyle = .crossDissolve
                pass.modalPresentationStyle = .overFullScreen
                owner.present(pass, animated: true)
                pass.setup(
                    name: data.userName,
                    info: "\(data.grade ?? 0)학년 \(data.classNum ?? 0)반 \(data.num ?? 0)번",
                    time: "\(data.start ?? "") ~ \(data.end ?? "")",
                    reason: data.reason,
                    teacher: "\(data.teacherName) 선생님"
                )
            }.disposed(by: disposeBag)

        output.selfStudyData.asObservable()
            .withUnretained(self)
            .bind { owner, data in
                owner.selfStudyBannerView.setup(
                    selfStudyTeacherData: data
                )
            }.disposed(by: disposeBag)

        output.timeTableHeight.asObservable()
            .withUnretained(self)
            .bind { owner, height in
                if height == 0 {
                    owner.timeTableHeight.accept(100)
                } else {
                    owner.timeTableHeight.accept(height)
                }

                owner.setupViewType(type: owner.homeViewType)
            }.disposed(by: disposeBag)

        output.schoolMealHeight.asObservable()
            .withUnretained(self)
            .bind { owner, height in
                owner.schoolMealHeight.accept(height)
                owner.setupViewType(type: owner.homeViewType)
            }.disposed(by: disposeBag)

        output.noticeViewHeight.asObservable()
            .withUnretained(self)
            .bind { owner, height in
                if height == 0 {
                    owner.noticeStackView.isHidden = true
                }
                owner.noticeCollectionView.snp.remakeConstraints {
                    $0.height.equalTo(height)
                }
            }.disposed(by: disposeBag)
    }
    public override func addView() {
        [
            navigationBar,
            scrollView
        ].forEach { view.addSubview($0) }

        scrollView.addSubview(contentView)

        [
            headerStackView,
            mainView
        ].forEach { contentView.addSubview($0) }

       [
            mainStackView,
            selfStudyBannerView,
            noticeStackView
       ].forEach { mainView.addArrangedSubview($0) }
    }

    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }

        headerStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }

        mainView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupViewType(type: HomeViewType) {
        switch type {
        case .timeTable:
            self.todaysLabel.text = "오늘의 시간표"
            self.schoolMealView.isHidden = true
            self.timeTableView.isHidden = false

            mainStackView.snp.remakeConstraints {
                $0.height.equalTo(self.timeTableHeight.value)
            }

        case .schoolMeal:
            self.todaysLabel.text = "오늘의 급식"
            self.timeTableView.isHidden = true
            self.schoolMealView.isHidden = false

            mainStackView.snp.remakeConstraints {
                $0.height.equalTo(self.schoolMealHeight.value)
            }
        }
    }

}
