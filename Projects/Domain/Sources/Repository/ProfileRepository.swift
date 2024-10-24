import Foundation

import RxSwift

public protocol ProfileRepository {
    func fetchSimpleProfile() -> Single<SimpleProfileEntity>
    func fetchDetailProfile() -> Single<DetailProfileEntity>
    func uploadProfileImage(image: Data) -> Completable
}
