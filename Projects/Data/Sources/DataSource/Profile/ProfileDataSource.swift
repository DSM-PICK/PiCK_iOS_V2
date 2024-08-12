import Foundation

import RxSwift
import Moya
import RxMoya

import AppNetwork
import Domain

protocol ProfileDataSource {
    func fetchSimpleProfile() -> Single<Response>
    func fetchDetailProfile() -> Single<Response>
}

class ProfileDataSourceImpl: BaseDataSource<ProfileAPI>, ProfileDataSource {
    func fetchSimpleProfile() -> Single<Response> {
        return request(.fetchSimpleProfile)
            .filterSuccessfulStatusCodes()
    }

    func fetchDetailProfile() -> Single<Response> {
        return request(.fetchDetailProfile)
            .filterSuccessfulStatusCodes()
    }

}
