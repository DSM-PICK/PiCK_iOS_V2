import Foundation

import RxSwift

import Domain

class ProfileRepositoryImpl: ProfileRepository {

    let remoteDataSource = ProfileDataSource.shared
    
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
