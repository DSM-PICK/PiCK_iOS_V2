import UIKit

import Core

public class PiCKLabel: BaseLabel {

    public init(
        text: String? = nil,
        textColor: UIColor? = .clear,
        font: UIFont? = .body1,
        numberOfLines: Int? = 0,
        alignment: NSTextAlignment? = .left,
        backgroundColor: UIColor? = .clear,
        cornerRadius: CGFloat? = 0,
        isHidden: Bool? = false
    ) {
        super.init(frame: .zero)
        setupLabel(
            text: text,
            textColor: textColor,
            font: font,
            numberOfLines: numberOfLines,
            alignment: alignment,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            isHidden: isHidden
        )
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel(
        text: String?,
        textColor: UIColor?,
        font: UIFont?,
        numberOfLines: Int?,
        alignment: NSTextAlignment?,
        backgroundColor: UIColor?,
        cornerRadius: CGFloat?,
        isHidden: Bool?
    ) {
        self.text = text
        self.textColor = textColor
        self.font = font
        self.numberOfLines = numberOfLines ?? 0
        self.textAlignment = alignment ?? .left
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius ?? 0
        self.isHidden = isHidden ?? false
        self.clipsToBounds = true
    }

}
