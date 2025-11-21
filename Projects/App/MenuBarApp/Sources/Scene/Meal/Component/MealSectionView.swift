import Cocoa
import SnapKit
import Then
import Combine
import MenuBarDesignSystem
import MenuBarNetwork

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
