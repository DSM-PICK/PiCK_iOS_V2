import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

class AccountSectionView: BaseView {
    enum AccountSectionType: Int {
        case myPage
        case changePassword
        case logOut
        case resign
    }

    private let accountSectionView = PiCKSectionView(
        menuText: "계정",
        items: [
            ("마이페이지", .myPage, .main700),
            ("비밀번호 변경", .changePassword, .main700),
            ("로그아웃", .logout, .error),
            ("회원탈퇴", .resign, .error)
        ]
    )

    override func layout() {
        self.addSubview(accountSectionView)

        accountSectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getSelectedItem(type: AccountSectionType) -> Observable<IndexPath> {
        self.accountSectionView.getSelectedItem(index: type.rawValue)
    }

}
