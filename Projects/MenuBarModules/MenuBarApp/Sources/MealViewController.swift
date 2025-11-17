import Cocoa
import SnapKit
import Then

class MealViewController: BaseNSViewController {

    private let scrollView = NSScrollView()
    private let stackView = NSStackView()
    private let titleLabel = NSTextField(labelWithString: "오늘의 급식")

    private let breakfastSection = MealSectionView(mealType: "조식")
    private let lunchSection = MealSectionView(mealType: "중식")
    private let dinnerSection = MealSectionView(mealType: "석식")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTestData()
    }

    override func setupUI() {
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor

        titleLabel.do {
            $0.font = NSFont.boldSystemFont(ofSize: 20)
            $0.alignment = .center
        }

        stackView.do {
            $0.orientation = .vertical
            $0.spacing = 20
            $0.alignment = .leading
            $0.distribution = .fill
            $0.edgeInsets = NSEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
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
        }

        view.addSubview(titleLabel)
        view.addSubview(scrollView)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.width.equalTo(scrollView)
        }
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
    private let kcalLabel = NSTextField(labelWithString: "")
    private let menuLabel = NSTextField(wrappingLabelWithString: "")
    private let containerBox = NSBox()
    private let infoStackView = NSStackView()

    init(mealType: String) {
        super.init(frame: NSRect(x: 0, y: 0, width: 360, height: 154))
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
            $0.borderColor = NSColor.systemBlue.withAlphaComponent(0.2)
            $0.cornerRadius = 8
            $0.fillColor = NSColor.white
        }

        mealTypeLabel.do {
            $0.font = NSFont.boldSystemFont(ofSize: 16)
            $0.textColor = NSColor.systemBlue
            $0.isEditable = false
            $0.isBordered = false
            $0.backgroundColor = .clear
            $0.alignment = .center
        }

        kcalLabel.do {
            $0.font = NSFont.systemFont(ofSize: 12)
            $0.textColor = NSColor.white
            $0.backgroundColor = NSColor.systemBlue
            $0.alignment = .center
            $0.wantsLayer = true
            $0.layer?.cornerRadius = 12
            $0.layer?.masksToBounds = true
            $0.isEditable = false
            $0.isBordered = false
        }

        menuLabel.do {
            $0.font = NSFont.systemFont(ofSize: 14)
            $0.textColor = NSColor.black
            $0.isEditable = false
            $0.isBordered = false
            $0.backgroundColor = .clear
            $0.maximumNumberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.preferredMaxLayoutWidth = 150
        }

        infoStackView.do {
            $0.orientation = .vertical
            $0.spacing = 16
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
            $0.height.equalTo(154)
            $0.width.equalTo(360)
        }

        containerBox.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        infoStackView.snp.makeConstraints {
            $0.centerY.equalTo(containerBox)
            $0.leading.equalTo(containerBox).offset(40)
        }

        kcalLabel.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(22)
        }

        menuLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(containerBox).inset(10)
            $0.leading.equalTo(containerBox).offset(180)
            $0.trailing.equalTo(containerBox).inset(10)
        }
    }

    func configure(menu: [String], kcal: String) {
        if menu.isEmpty {
            menuLabel.stringValue = "급식이 없습니다"
            kcalLabel.isHidden = true
        } else {
            menuLabel.stringValue = menu.joined(separator: "\n")
            kcalLabel.stringValue = kcal
            kcalLabel.isHidden = false
        }
    }
}
