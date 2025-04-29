import UIKit

import Kingfisher

public extension UIImageView {
    func setImage(with urlString: String, placeholder: UIImage? = nil) {
        if let placeholder = placeholder {
            self.image = placeholder
        }
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self.image = image
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource, placeholder: placeholder)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
