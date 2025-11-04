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
        font: .pickFont(.heading4)
    )
    private let explainLabel = PiCKLabel(
        text: "자습 감독 선생님께서 수락 후 이동할 수 있습니다.",
        textColor: .gray600,
        font: .pickFont(.body2)
    )
    private let floorSegmentedControl = ClassroomSegmentedControl(items:
        ClassroomData.shared.allFloors.enumerated().map { index, _ in
            "\(index + 1)층"
        }
    ).then {
        $0.selectedSegmentIndex = 0
    }
    private lazy var backgroundcollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    private lazy var backgroundCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: backgroundcollectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.register(
            ClassroomBackgroundCell.self,
            forCellWithReuseIdentifier: ClassroomBackgroundCell.identifier
        )
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.bounces = false
    }
    private let nextButton = PiCKButton(buttonText: "다음")

    public override func attribute() {
        super.attribute()
        navigationTitleText = "교실 이동 신청"
        backgroundCollectionView.contentInsetAdjustmentBehavior = .never
    }
    public override func bind() {
        let input = ClassroomMoveApplyViewModel.Input(
            floorText: selectedSegemetedControlIndex.asObservable(),
            classroomText: classroomText.asObservable(),
            startPeriod: startPeriod.asObservable(),
            endPeriod: endPeriod.asObservable(),
            classroomMoveApplyButtonDidTap: classroomMoveApplyRelay.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.isApplyButtonEnable
            .asObservable()
            .withUnretained(self)
            .bind { owner, isEnabled in
                owner.nextButton.isEnabled = isEnabled
            }.disposed(by: disposeBag)

        floorSegmentedControl.rx.selectedSegmentIndex
            .withUnretained(self)
            .map { owner, index -> [String] in
                owner.selectedSegemetedControlIndex.accept(index + 1)
                owner.classroomText.accept("")
                let itemCount = owner.backgroundCollectionView.numberOfItems(inSection: 0)

                guard itemCount > 0, index < itemCount else {
                    return owner.classroomData.firstFloor
                }

                owner.backgroundCollectionView.scrollToItem(
                    at: IndexPath(item: index, section: 0),
                    at: .centeredHorizontally,
                    animated: false
                )

                switch index {
                case 0:
                    return owner.classroomData.firstFloor
                case 1:
                    return owner.classroomData.secondFloor
                case 2:
                    return owner.classroomData.thirdFloor
                case 3:
                    return owner.classroomData.fourthFloor
                case 4:
                    return owner.classroomData.fifthFloor
                default:
                    return owner.classroomData.firstFloor
                }
            }
            .bind(to: currentFloorClassroomArray)
            .disposed(by: disposeBag)

        Observable.just(classroomData.allFloors)
            .bind(to: backgroundCollectionView.rx.items(
                cellIdentifier: ClassroomBackgroundCell.identifier,
                cellType: ClassroomBackgroundCell.self
            )) { _, item, cell in
                cell.setup(data: item)
                cell.didSelectClassroom = { [weak self] classroom in
                    self?.classroomText.accept(classroom)
                }
            }.disposed(by: disposeBag)

        backgroundCollectionView.rx.didScroll
            .withUnretained(self)
            .bind { owner, _ in
                guard let layout = owner.backgroundCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

                let cellWidth = layout.itemSize.width
                let spacing = layout.minimumLineSpacing
                let totalCellWidth = cellWidth + spacing

                let offset = owner.backgroundCollectionView.contentOffset.x + owner.backgroundCollectionView.contentInset.left
                let index = Int(round(offset / totalCellWidth))

                owner.floorSegmentedControl.selectedSegmentIndex = index
            }
            .disposed(by: disposeBag)

        nextButton.buttonTap
            .bind { [weak self] in
                let alert = PiCKApplyTimePickerAlert(type: .classroom)

                alert.selectedPeriod = { [weak self] startPeriod, endPeriod in
                    self?.startPeriod.accept(startPeriod)
                    self?.endPeriod.accept(endPeriod)
                }
                alert.applyButtonDidTap = { [weak self] in
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
            backgroundCollectionView,
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
        backgroundCollectionView.snp.makeConstraints {
            $0.top.equalTo(floorSegmentedControl.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(60)
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let safeHeight = view.frame.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom

        if let layout = backgroundCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let newSize = CGSize(
                width: view.frame.width - 48,
                height: safeHeight * 0.7
            )

            if layout.itemSize != newSize {
                layout.itemSize = newSize
                layout.invalidateLayout()
            }
        }
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async { [weak self] in
            guard let self,
                  let layout = self.backgroundCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.invalidateLayout()
        }
    }

}
