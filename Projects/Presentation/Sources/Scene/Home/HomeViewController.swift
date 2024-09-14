import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import Domain
import DesignSystem

public class HomeViewController: BaseViewController<HomeViewModel> {
    private var homeViewType: HomeViewType = .timeTable

    private var timeTableData = BehaviorRelay<[TimeTableEntityElement]>(value: [])
    private var schoolMealData = BehaviorRelay<[(Int, String, MealEntityElement)]>(value: [])

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
    private let mainView = UIView()

    private lazy var navigationBar = PiCKMainNavigationBar(view: self)
    private let profileView = PiCKProfileView()

    private let passHeaderView = HomePassHeaderView()
    private let todaysLabel = PiCKLabel(
        textColor: .gray700,
        font: .label1
    )

    private lazy var timeTableView = HomeTimeTableView(frame: subViewSize)
    private lazy var schoolMealView = HomeSchoolMealView(frame: subViewSize)
    private lazy var mainStackView = UIStackView(arrangedSubviews: [
        timeTableView,
        schoolMealView
    ]).then {
        $0.axis = .vertical
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
    private let noticeHeaderView = HomeHeaderView().then {
        $0.setup(title: "공지공지공지", explain: "새로운 공지를 확인해보세요")
        $0.isHidden = true
    }
    private lazy var noticeCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: self.view.frame.width, height: 81)
        $0.minimumLineSpacing = 5
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
        noticeHeaderView,
        noticeCollectionView
    ]).then {
        $0.axis = .vertical
        $0.spacing = 20
    }

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = HomeViewModel.Input(
            viewWillApper: viewWillAppearRelay.asObservable(),
            clickAlert: navigationBar.alertButtonTap.asObservable(),
            clickOutingPass: passHeaderView.buttonTap.asObservable(),
            clickViewMoreNotice: viewMoreButton.rx.tap.asObservable(),
            todayDate: todayDate.toString(type: .fullDate)
        )
        let output = viewModel.transform(input: input)

        output.viewMode.asObservable()
            .bind(onNext: { [weak self] data in
                self?.setupViewType(type: data)
            }).disposed(by: disposeBag)

        output.applyStatusData.asObservable()
            .bind(onNext: { [weak self] data in
//                data?.type
                let isEmpty = data?.type?.isEmpty
                self?.passHeaderView.isHidden = isEmpty!
                self?.passHeaderView.setup(type: .application)
//                self?.testButton.setup(type: .outing)
//                self?.testButton.isHidden = false
            }).disposed(by: disposeBag)

        output.timetableData.asObservable()
            .bind(onNext: { [weak self] data in
                self?.timeTableData.accept(data)
            }).disposed(by: disposeBag)

        output.schoolMealData.asObservable()
            .bind(onNext: { [weak self] data in
                self?.schoolMealData.accept(data)
            }).disposed(by: disposeBag)

        output.noticeListData.asObservable()
            .bind(to: noticeCollectionView.rx.items(
                cellIdentifier: NoticeCollectionViewCell.identifier,
                cellType: NoticeCollectionViewCell.self
            )) { row, item, cell in
                cell.adapt(model: item)
            }.disposed(by: disposeBag)

        output.outingPassData.asObservable()
            .bind(onNext: { [weak self] data in
                let alert = PassView()
                alert.modalTransitionStyle = .crossDissolve
                alert.modalPresentationStyle = .overFullScreen
                self?.present(alert, animated: true)
                alert.setup(
                    name: data.userName,
                    info: "\(data.grade ?? 0)학년 \(data.classNum ?? 0)반 \(data.num ?? 0)번",
                    time: "\(data.start ?? "") ~ \(data.end ?? "")",
                    reason: data.reason,
                    teacher: "\(data.teacherName) 선생님"
                )
            }).disposed(by: disposeBag)

        output.selfStudyData.asObservable()
            .bind(onNext: { [weak self] data in
                self?.selfStudyBannerView.setup(selfStudyTeacherData: data)
            }).disposed(by: disposeBag)

        output.timeTableHeight.asObservable()
            .bind(onNext: { [weak self] height in
                if height == 0 {
                    self?.timeTableHeight.accept(50)
                } else {
                    self?.timeTableHeight.accept(height)
                }
                self?.setLayout()
            }).disposed(by: disposeBag)

        output.schoolMealHeight.asObservable()
            .bind(onNext: { [weak self] height in
                self?.schoolMealHeight.accept(height)
                self?.setLayout()
            }).disposed(by: disposeBag)

        output.noticeViewHeight.asObservable()
            .bind(onNext: { [weak self] height in
                self?.noticeCollectionView.snp.remakeConstraints {
                    $0.height.equalTo(height)
                }
                self?.setLayout()
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
            passHeaderView,
            todaysLabel,
            mainStackView,
            selfStudyBannerView,
            noticeStackView
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
            $0.height.equalTo(self.view.frame.height * 2)
        }

        passHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(72)
        }
        todaysLabel.snp.makeConstraints {
            $0.top.equalTo(passHeaderView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(todaysLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        selfStudyBannerView.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(160)
        }
        noticeStackView.snp.makeConstraints {
            $0.top.equalTo(selfStudyBannerView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        noticeHeaderView.snp.makeConstraints {
            $0.height.equalTo(81)
        }
    }

    private func setupViewType(type: HomeViewType) {
        switch type {
        case .timeTable:
            self.todaysLabel.text = "오늘의 시간표"
            self.schoolMealView.isHidden = true
            self.timeTableView.isHidden = false
            self.timeTableView.setup(timeTableData: self.timeTableData.value)
            mainStackView.snp.remakeConstraints {
                $0.height.equalTo(self.timeTableHeight.value)
            }
        case .schoolMeal:
            self.todaysLabel.text = "오늘의 급식"
            self.timeTableView.isHidden = true
            self.schoolMealView.isHidden = false
            self.schoolMealView.setup(schoolMealData: self.schoolMealData.value)
            mainStackView.snp.remakeConstraints {
                $0.height.equalTo(self.schoolMealHeight.value)
            }
        }
    }

}
