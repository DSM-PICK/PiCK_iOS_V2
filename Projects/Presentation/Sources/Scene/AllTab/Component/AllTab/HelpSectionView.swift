import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

class HelpSectionView: BaseView {
    
    enum HelpSectionType: Int {
        case notice
        case selfStudy
        case bugReport
    }
    
    private let helpSectionView = PiCKSectionView(
        menuText: "도움말",
        items: [
            ("공지사항", .voice),
            ("자습 감독 선생님 확인", .smile),
            ("버그 제보", .bug)
        ]
    )

    override func layout() {
        self.addSubview(helpSectionView)

        helpSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: HelpSectionType) -> Observable<IndexPath> {
        self.helpSectionView.getSelectedItem(index: type.rawValue)
    }

}
