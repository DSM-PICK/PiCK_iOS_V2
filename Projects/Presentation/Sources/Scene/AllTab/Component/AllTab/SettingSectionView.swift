import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

class SettingSectionView: BaseView {
    enum SettingSectionType: Int {
        case custom
        case notification
    }

    private let settingSectionView = PiCKSectionView(
        menuText: "설정",
        items: [
            ("커스텀", .navigationSetting, .main700),
            ("알림 설정", .alert, .main700)
        ]
    )

    override func layout() {
        self.addSubview(settingSectionView)

        settingSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: SettingSectionType) -> Observable<IndexPath> {
        self.settingSectionView.getSelectedItem(index: type.rawValue)
    }

}
