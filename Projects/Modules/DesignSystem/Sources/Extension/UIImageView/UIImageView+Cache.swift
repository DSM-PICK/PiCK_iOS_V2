import UIKit

import Kingfisher

public extension UIImageView {
    /// Sets the image of the UIImageView using a URL string, retrieving it from cache if available or downloading it if not.
    ///
    /// If the image is cached with the given URL string as the key, it is set immediately. Otherwise, the image is downloaded asynchronously and cached for future use. If the URL string is invalid or an error occurs during cache retrieval, the image is not set.
    func setImage(with urlString: String) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self.image = image
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = KF.ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
