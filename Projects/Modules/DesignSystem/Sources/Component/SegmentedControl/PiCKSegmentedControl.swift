import UIKit

import SnapKit
import Then

import RxSwift
import RxCocoa

import Core

public class PiCKSegmentedControl: UISegmentedControl {
    
    private lazy var radius: CGFloat = self.frame.height / 2
    private var segmentInset: CGFloat = 7
    
    public override init(items: [Any]?) {
        super.init(items: items)
        self.selectedSegmentIndex = 0
        self.backgroundColor = .red
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews(){
        super.layoutSubviews()
        setup()
        layout()
    }
    
    private func setup() {
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.blue,
            .font: UIFont.body2
        ], for: .normal)
        self.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.yellow
        ],for: .selected)
        self.layer.cornerRadius = self.radius
        self.layer.masksToBounds = true
    }
    private func layout() {
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView
        {
            selectedImageView.backgroundColor = .white
            selectedImageView.image = nil
            
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            
            selectedImageView.layer.masksToBounds = true
            selectedImageView.layer.cornerRadius = self.radius - (segmentInset / 2)
            
            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")
            
        }
    }
   
}