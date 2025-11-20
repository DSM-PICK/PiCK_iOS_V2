import Cocoa
import SnapKit
import Then
import MenuBarDesignSystem

class MealViewController: BaseNSViewController {
    private let scrollView = NSScrollView()
    private let stackView = NSStackView()
    private let headerView = NSView()
    private let titleLabel = NSTextField(labelWithString: "오늘의 급식")
    private let dateLabel = NSTextField(labelWithString: "")

    private let breakfastSection = MealSectionView(mealType: "조식")
    private let lunchSection = MealSectionView(mealType: "중식")
    private let dinnerSection = MealSectionView(mealType: "석식")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTestData()
        updateDate()
    }

    override func setupUI() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.pickBackground.cgColor

        headerView.wantsLayer = true

        titleLabel.do {
            $0.font = NSFont.systemFont(ofSize: 18, weight: .semibold)
            $0.textColor = .pickModeBlack
            $0.alignment = .left
            $0.isEditable = false
            $0.isBordered = false
            $0.backgroundColor = .clear
        }

        dateLabel.do {
            $0.font = NSFont.systemFont(ofSize: 13)
            $0.textColor = .secondaryLabelColor
            $0.alignment = .left
            $0.isEditable = false
            $0.isBordered = false
            $0.backgroundColor = .clear
        }

        stackView.do {
            $0.orientation = .vertical
            $0.spacing = 12
            $0.alignment = .leading
            $0.distribution = .fill
            $0.edgeInsets = NSEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            $0.addArrangedSubview(breakfastSection)
            $0.addArrangedSubview(lunchSection)
            $0.addArrangedSubview(dinnerSection)
        }

        scrollView.do {
            $0.documentView = stackView
            $0.hasVerticalScroller = true
            $0.autohidesScrollers = true
            $0.borderType = .noBorder
            $0.backgroundColor = .clear
            $0.drawsBackground = false
        }

        headerView.addSubview(titleLabel)
        headerView.addSubview(dateLabel)
        view.addSubview(headerView)
        view.addSubview(scrollView)
    }

    override func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.width.equalTo(scrollView)
        }
    }

    private func updateDate() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        dateLabel.stringValue = formatter.string(from: Date())
    }

    private func loadTestData() {
        let testBreakfast = [
            "밥",
            "된장찌개",
            "김치",
            "계란후라이"
        ]

        let testLunch = [
            "카레라이스",
            "돈까스",
            "단무지",
            "요구르트"
        ]

        let testDinner = [
            "비빔밥",
            "미역국",
            "불고기",
            "배추김치"
        ]

        breakfastSection.configure(menu: testBreakfast, kcal: "650 kcal")
        lunchSection.configure(menu: testLunch, kcal: "850 kcal")
        dinnerSection.configure(menu: testDinner, kcal: "720 kcal")
    }
}

class MealSectionView: NSView {
    private let mealTypeLabel = NSTextField(labelWithString: "")
    private let kcalLabel = PaddedTextField(labelWithString: "")
    private let menuLabel = NSTextField(wrappingLabelWithString: "")
    private let containerBox = NSBox()
    private let infoStackView = NSStackView()

    init(mealType: String) {
        super.init(frame: NSRect(x: 0, y: 0, width: 360, height: 130))
        mealTypeLabel.stringValue = mealType
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        wantsLayer = true

        containerBox.do {
            $0.boxType = .custom
            $0.borderType = .lineBorder
            $0.borderWidth = 2
            $0.borderColor = .pickMain50
            $0.cornerRadius = 8
            $0.fillColor = .pickBackground
        }

        mealTypeLabel.do {
            $0.font = NSFont.systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = .pickMain700
            $0.isEditable = false
            $0.isBordered = false
            $0.backgroundColor = .clear
            $0.alignment = .center
        }

        kcalLabel.do {
            $0.font = NSFont.systemFont(ofSize: 11)
            $0.textColor = .white
            $0.backgroundColor = .pickMain500
            $0.alignment = .center
            $0.wantsLayer = true
            $0.layer?.cornerRadius = 11
            $0.layer?.masksToBounds = true
            $0.isEditable = false
            $0.isBordered = false
        }

        menuLabel.do {
            $0.font = NSFont.systemFont(ofSize: 13)
            $0.textColor = .pickModeBlack
            $0.isEditable = false
            $0.isBordered = false
            $0.backgroundColor = .clear
            $0.maximumNumberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.preferredMaxLayoutWidth = 140
        }

        infoStackView.do {
            $0.orientation = .vertical
            $0.spacing = 12
            $0.alignment = .centerX
            $0.distribution = .fill
            $0.addArrangedSubview(mealTypeLabel)
            $0.addArrangedSubview(kcalLabel)
        }

        addSubview(containerBox)
        containerBox.addSubview(infoStackView)
        containerBox.addSubview(menuLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(130)
            $0.width.equalTo(360)
        }

        containerBox.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        infoStackView.snp.makeConstraints {
            $0.centerY.equalTo(containerBox)
            $0.leading.equalTo(containerBox).offset(32)
        }

        kcalLabel.snp.makeConstraints {
            $0.width.equalTo(76)
            $0.height.equalTo(24)
        }

        menuLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(containerBox).inset(16)
            $0.leading.equalTo(containerBox).offset(170)
            $0.trailing.equalTo(containerBox).inset(16)
        }
    }

    func configure(menu: [String], kcal: String) {
        if menu.isEmpty {
            menuLabel.stringValue = "급식이 없습니다"
            menuLabel.textColor = .secondaryLabelColor
            kcalLabel.isHidden = true
        } else {
            menuLabel.stringValue = menu.joined(separator: "\n")
            menuLabel.textColor = .pickModeBlack
            kcalLabel.stringValue = kcal
            kcalLabel.isHidden = false
        }
    }
}

class PaddedTextField: NSTextField {
    override var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        size.width += 12
        return size
    }
}
