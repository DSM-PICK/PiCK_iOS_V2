import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ScheduleViewController: BaseViewController<ScheduleViewModel> {
    private let shouldHideFirstViewRelay = BehaviorRelay<Bool>(value: true)

    private var shouldHideFirstView: Observable<Bool> {
        return shouldHideFirstViewRelay.asObservable()
    }

    private lazy var viewSize = CGRect(
        x: 0,
        y: 0,
        width: self.view.frame.width,
        height: self.view.frame.height - 184
    )

    private lazy var navigationBar = PiCKMainNavigationBar(view: self)

    private let segmentedControl = ScheduleSegmentedControl(items: ["시간표", "학사일정"])
    private lazy var timeTableView = TimeTableView(frame: viewSize)
    private lazy var academicScheduleView = AcademicScheduleView(frame: viewSize)

    public override func configureNavgationBarLayOutSubviews() {
        super.configureNavgationBarLayOutSubviews()

        navigationController?.isNavigationBarHidden = true
    }
    public override func bind() {
        let input = ScheduleViewModel.Input(
            loadTimeTable: viewWillAppearRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.timeTableData.asObservable()
            .subscribe(onNext: { [weak self] data in
                self?.timeTableView.timeTableSetup(
                    timeTableData: data
                )
            }).disposed(by: disposeBag)

        segmentedControl.rx.selectedSegmentIndex
            .map { $0 != 0 }
            .bind(to: shouldHideFirstViewRelay)
            .disposed(by: disposeBag)
        
        shouldHideFirstView
            .subscribe(
                onNext: { [weak self] shouldHide in
                    self?.timeTableView.isHidden = shouldHide
                    self?.academicScheduleView.isHidden = !shouldHide
                }
            )
            .disposed(by: disposeBag)
    }
    public override func addView() {
        [
            navigationBar,
            segmentedControl,
            timeTableView,
            academicScheduleView
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(46)
        }
        timeTableView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(40)
        }
        academicScheduleView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(400)
        }
    }

}
