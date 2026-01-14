import UIKit

import Kingfisher

public extension UIImageView {
    func setImage(with urlString: String, placeholder: UIImage? = nil, downsampleSize: CGSize? = nil) {
        guard let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }

        var options: KingfisherOptionsInfo = [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(0.2)),
            .cacheOriginalImage
        ]

        if let size = downsampleSize {
            let resizedSize = CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale)
            let processor = DownsamplingImageProcessor(size: resizedSize)
            options.append(.processor(processor))
        }

        self.kf.setImage(with: url, placeholder: placeholder, options: options)
    }

}
