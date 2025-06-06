import UIKit
import PhotosUI

import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture

import Core
import DesignSystem

public class BugReportViewController: BaseViewController<BugReportViewModel> {
    private var imageArray: [UIImage] = []
    private var bugImageArray = BehaviorRelay<[UIImage]>(value: [])
    private var dataArray: [Data] = []
    private var bugDataArray = BehaviorRelay<[Data]>(value: [])

    private let bugTitleView = BugReportView(type: .location)
    private let bugExplainView = BugReportView(type: .explain)
    private let bugImageLabel = PiCKLabel(
        text: "버그 사진을 첨부해주세요",
        textColor: .modeBlack,
        font: .pickFont(.label1)
    )
    private let bugImageView = BugImageView()
    private lazy var collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: 100, height: 100)
    }
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewFlowLayout
    ).then {
        $0.backgroundColor = .background
        $0.register(
            BugImageCollectionViewCell.self,
            forCellWithReuseIdentifier: BugImageCollectionViewCell.identifier
        )
        $0.isHidden = true
    }
    private lazy var bugImageStackView = UIStackView(arrangedSubviews: [
        bugImageView,
        collectionView
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 16
        $0.distribution = .fillProportionally
    }
    private let reportButton = PiCKButton(buttonText: "제보하기")

    private var configuration = PHPickerConfiguration(photoLibrary: .shared())
    private lazy var pickerViewController = PHPickerViewController(configuration: configuration).then {
        $0.delegate = self
    }

    public override func attribute() {
        super.attribute()

        navigationTitleText = "버그 제보"
        phPickerSetting()
    }
    public override func bind() {
        let input = BugReportViewModel.Input(
            bugTitle: bugTitleView.titleText.asObservable(),
            bugContent: bugExplainView.contentText.asObservable(),
            bugImages: bugDataArray.asObservable(),
            bugReportButtonDidTap: reportButton.buttonTap.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.isReportButtonEnable
            .asObservable()
            .withUnretained(self)
            .bind { owner, isEnabled in
                owner.reportButton.isEnabled = isEnabled
            }.disposed(by: disposeBag)

        bugImageArray.bind(to: collectionView.rx.items(
            cellIdentifier: BugImageCollectionViewCell.identifier,
            cellType: BugImageCollectionViewCell.self
        )) { [weak self] row, item, cell in
            cell.setup(image: item)
            cell.deleteButtonTap
                .bind {
                    self?.imageArray.remove(at: row)
                    self?.dataArray.remove(at: row)

                    self?.bugImageArray.accept(self?.imageArray ?? [])
                    self?.bugDataArray.accept(self?.dataArray ?? [])

                    if self?.imageArray.isEmpty == true {
                        self?.collectionView.isHidden = true
                    }

                    self?.collectionView.reloadData()
                }.disposed(by: cell.disposeBag)
        }.disposed(by: disposeBag)
    }

    public override func bindAction() {
        super.bindAction()

        bugImageView.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .bind { owner, _ in
                owner.present(owner.pickerViewController, animated: true)
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            bugTitleView,
            bugExplainView,
            bugImageLabel,
            bugImageStackView,
            reportButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        bugTitleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(71)
        }
        bugExplainView.snp.makeConstraints {
            $0.top.equalTo(bugTitleView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(151)
        }
        bugImageLabel.snp.makeConstraints {
            $0.top.equalTo(bugExplainView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        bugImageStackView.snp.makeConstraints {
            $0.top.equalTo(bugImageLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(100)
        }
        reportButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
    }

    private func phPickerSetting() {
        configuration.filter = .images
        configuration.selectionLimit = 3
        configuration.selection = .ordered
        configuration.preferredAssetRepresentationMode = .current
    }

}

extension BugReportViewController: PHPickerViewControllerDelegate {
    public func picker(
        _ picker: PHPickerViewController,
        didFinishPicking results: [PHPickerResult]
    ) {
        self.dismiss(animated: true)

        if results.isEmpty {
            self.bugImageArray.accept([])
            self.imageArray.removeAll()
            self.collectionView.isHidden = true
        }

        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    guard let image = image as? UIImage, error == nil else { return }
                    let data = image.jpegData(compressionQuality: 0.1)

                    self?.imageArray.append(image)
                    self?.dataArray.append(data ?? Data())

                    if self?.imageArray.count == results.count {
                        self?.bugImageArray.accept(self?.imageArray ?? [])
                        self?.bugDataArray.accept(self?.dataArray ?? [])

                        DispatchQueue.main.async {
                            self?.collectionView.isHidden = false
                        }
                    }
                }
            }
        }
    }

}
