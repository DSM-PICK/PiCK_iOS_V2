import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class HomeViewController: BaseViewController<HomeViewModel> {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let mainView = UIView()
    
    private let navigationBar = PiCKMainNavigationBar()
    private let profileImageView = UIImageView(image: .profile)
    private let userInfoLabel = UILabel().then {
        //TODO: 행간 조절
        $0.text = "대덕소프트웨어마이스터고등학교\n2학년 4반 조영준"
        $0.textColor = .black
        $0.font = .label1
        $0.numberOfLines = 0
    }
    
    public override func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = true
//        navigationController.
//        navigationController?.navigationBar./
    }
    
    public override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainView)
        
        [
            navigationBar,
            profileImageView,
            userInfoLabel
        ].forEach { mainView.addSubview($0) }
    }
    
    public override func setLayout() {
        switch UITraitCollection.current.userInterfaceStyle {
        case .light:
            userInfoLabel.textColor = .black
        case .dark:
            userInfoLabel.textColor = .white
        default:
            return
            
        }
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(self.view)
        }
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.view.frame.height * 2)
        }
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(36)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(60)
        }
        userInfoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(46)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(24)
        }
    }

}

