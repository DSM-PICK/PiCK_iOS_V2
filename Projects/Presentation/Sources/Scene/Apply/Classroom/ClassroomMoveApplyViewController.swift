import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class ClassroomMoveApplyViewController: BaseViewController<ClassroomMoveApplyViewModel> {
    private let classroomData = ClassroomData.shared

    private let classroomMoveApplyRelay = PublishRelay<Void>()
    private var classroomText = BehaviorRelay<String>(value: "")
    private var startPeriod = BehaviorRelay<Int>(value: 1)
    private var endPeriod = BehaviorRelay<Int>(value: 1)
    private lazy var selectedSegemetedControlIndex = BehaviorRelay<Int>(value: 1)
    private lazy var currentFloorClassroomArray = BehaviorRelay<[String]>(value: classroomData.firstFloor)

    private let titleLabel = PiCKLabel(
        text: "교실 이동",
        textColor: .modeBlack,
        font: .heading4
    )
    private let explainLabel = PiCKLabel(
        text: "자습 감독 선생님께서 수락 후 이동할 수 있습니다.",
        textColor: .gray600,
        font: .body2
    )
    private let floorSegmentedControl = ClassroomSegmentedControl(items: [
        "1층", "2층", "3층", "4층", "5층"
    ]).then {
        $0.selectedSegmentIndex = 0
    }
    private lazy var collectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumLineSpacing = 15
        $0.minimumInteritemSpacing = 16
    }
    private lazy var classroomCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.register(
            ClassroomCollectionViewCell.self,
            forCellWithReuseIdentifier: ClassroomCollectionViewCell.identifier
        )
        $0.contentInsetAdjustmentBehavior = .always
        $0.bounces = false
    }
    private let nextButton = PiCKButton(buttonText: "다음")

    public override func attribute() {
        super.attribute()

        navigationTitleText = "교실 이동 신청"
    }
    public override func bind() {
        let input = ClassroomMoveApplyViewModel.Input(
            floorText: selectedSegemetedControlIndex.asObservable(),
            classroomText: classroomText.asObservable(),
            startPeriod: startPeriod.asObservable(),
            endPeriod: endPeriod.asObservable(),
            clickClassroomMoveApply: classroomMoveApplyRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.isApplyButtonEnable
            .asObservable()
            .withUnretained(self)
            .bind { owner, isEnabled in
                owner.nextButton.isEnabled = isEnabled
            }.disposed(by: disposeBag)

        floorSegmentedControl.rx.selectedSegmentIndex
            .map { [weak self] index -> [String] in
                self?.selectedSegemetedControlIndex.accept(index + 1)
                self?.classroomText.accept("")
                switch index {
                case 0:
                    return self?.classroomData.firstFloor ?? []
                case 1:
                    return self?.classroomData.secondFloor ?? []
                case 2:
                    return self?.classroomData.thirdFloor ?? []
                case 3:
                    return self?.classroomData.fourthFloor ?? []
                case 4:
                    return self?.classroomData.fifthFloor ?? []
                default:
                    return self?.classroomData.firstFloor ?? []
                }
            }
            .bind(to: currentFloorClassroomArray)
            .disposed(by: disposeBag)

        currentFloorClassroomArray
            .bind(to: classroomCollectionView.rx.items(
                cellIdentifier: ClassroomCollectionViewCell.identifier,
                cellType: ClassroomCollectionViewCell.self
            )) { _, item, cell in
                cell.setup(classroom: item)
            }.disposed(by: disposeBag)

        classroomCollectionView.rx.itemSelected
            .withUnretained(self)
            .bind { owner, index in
                owner.classroomText.accept(
                    owner.currentFloorClassroomArray.value[index.row]
                )
            }.disposed(by: disposeBag)

        nextButton.buttonTap
            .bind { [weak self] in
                let alert = PiCKApplyTimePickerAlert(type: .classroom)

                alert.selectedPeriod = { [weak self] startPeriod, endPeriod in
                    self?.startPeriod.accept(startPeriod)
                    self?.endPeriod.accept(endPeriod)
                }
                alert.clickApplyButton = { [weak self] in
                    self?.classroomMoveApplyRelay.accept(())
                }

                self?.presentAsCustomDents(view: alert, height: 406)
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            titleLabel,
            explainLabel,
            floorSegmentedControl,
            classroomCollectionView,
            nextButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        floorSegmentedControl.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(25)
        }
        classroomCollectionView.snp.makeConstraints {
            $0.top.equalTo(floorSegmentedControl.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

}
