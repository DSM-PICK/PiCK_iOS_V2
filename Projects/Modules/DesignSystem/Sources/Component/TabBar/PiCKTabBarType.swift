import UIKit

import Core

public struct TabItemInfo {
    let title: String
    let image: UIImage
    let selectedImage: UIImage
    let tag: Int
}

public enum PiCKTabBarType: Int {
    case home, schoolMeal, apply, schedule, allTab

    func tabItemTuple() -> TabItemInfo {
        switch self {
        case .home:
            return .init(
                title: "홈",
                image: .homeIcon,
                selectedImage: .homeIcon,
                tag: 0
            )
        case .schoolMeal:
            return .init(
                title: "급식",
                image: .schoolMealIcon,
                selectedImage: .schoolMealIcon,
                tag: 1
            )
        case .apply:
            return .init(
                title: "신청",
                image: .applyIcon,
                selectedImage: .applyIcon,
                tag: 2
            )
        case .schedule:
            return .init(
                title: "일정",
                image: .scheduleIcon,
                selectedImage: .scheduleIcon,
                tag: 3
            )
        case .allTab:
            return .init(
                title: "전체",
                image: .allTabIcon,
                selectedImage: .allTabIcon,
                tag: 3
            )
        }
    }

}

public class PiCkTabBarTypeItem: UITabBarItem {
    public init(_ type: PiCKTabBarType) {
        super.init()
        let info = type.tabItemTuple()

        self.title = info.title
        self.image = info.image
        self.selectedImage = info.selectedImage
        self.tag = info.tag
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
