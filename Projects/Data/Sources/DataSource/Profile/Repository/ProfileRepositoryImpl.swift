import Foundation

import RxSwift

import Domain

class ProfileRepositoryImpl: ProfileRepository {
    private let remoteDataSource: ProfileDataSource

    init(remoteDataSource: ProfileDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchSimpleProfile() -> Single<SimpleProfileEntity> {
        return remoteDataSource.fetchSimpleProfile()
            .map(SimpleProfileDTO.self)
            .map { $0.toDomain() }
    }

    func fetchDetailProfile() -> Single<DetailProfileEntity> {
        return remoteDataSource.fetchDetailProfile()
            .map(DetailProfileDTO.self)
            .map { $0.toDomain() }
    }

}
