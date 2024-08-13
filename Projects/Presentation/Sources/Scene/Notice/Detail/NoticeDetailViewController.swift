import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class NoticeDetailViewController: BaseViewController<NoticeDetailViewModel> {
    private let loadNoticeDetailRelay = PublishRelay<UUID>()

    public var id: UUID = UUID()

    private let titleLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .subTitle1
    )
    private let dateLabel = PiCKLabel(
        textColor: .gray500,
        font: .body1
    )
    private let teacherNameLabel = PiCKLabel(
        textColor: .gray500,
        font: .body1
    )
    private lazy var subTextStackView = UIStackView(arrangedSubviews: [
        dateLabel,
        teacherNameLabel
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    private let lineView = UIView().then {
        $0.backgroundColor = .gray50
    }

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainView = UIView()
    private let contentLabel = PiCKLabel(
        textColor: .modeBlack,
        font: .body1
    )

    public override func attribute() {
        super.attribute()

        navigationTitleText = "공지사항"
    }

    public override func bindAction() {
        loadNoticeDetailRelay.accept(id)
    }
    public override func bind() {
        let input = NoticeDetailViewModel.Input(
            viewWillAppear: loadNoticeDetailRelay.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.noticeDetailData.asObservable()
            .bind(onNext: { [weak self] noticeData in
                self?.titleLabel.text = noticeData.title
                self?.dateLabel.text = noticeData.createAt
                self?.teacherNameLabel.text = noticeData.teacher
                self?.contentLabel.text = noticeData.content
            }).disposed(by: disposeBag)
    }
    public override func addView() {
        [
            titleLabel,
            subTextStackView,
            lineView,
            scrollView
        ].forEach { view.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(mainView)
        
        mainView.addSubview(contentLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        subTextStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(subTextStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(1)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.view.frame.height * 1.2)
        }
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(24)
        }

    }

}
