import UIKit

public extension UIFont {
    static func pickFont(_ font: PiCKFontStyle) -> UIFont {
        return font.uiFont()
    }
}

extension PiCKFontStyle {
    func uiFont() -> UIFont {
        let wantedSans = DesignSystemFontFamily.WantedSans.self

        switch self {

        case .heading1, .heading2, .heading3, .heading4, .subTitle1, .subTitle2, .subTitle3, .button1, .button2:
            return wantedSans.semiBold.font(size: self.size())

        case .body1, .body2, .body3, .label1, .label2:
            return wantedSans.medium.font(size: self.size())

        case .caption1, .caption2:
            return wantedSans.regular.font(size: self.size())
        }
    }

    func size() -> CGFloat {
        switch self {

        case .heading1:
            return 42

        case .heading2:
            return 32

        case .heading3:
            return 24

        case .heading4:
            return 20

        case .subTitle1:
            return 18

        case .subTitle2, .caption1, .label1, .button1:
            return 16

        case .subTitle3, .body1:
            return 14

        case .body2, .caption2, .label2, .button2:
            return 12

        case .body3:
            return 10
        }
    }

}
