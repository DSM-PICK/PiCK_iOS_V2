import Foundation

import RxSwift

import Domain

class SelfStudyRepositoryImpl: SelfStudyRepository {
    let remoteDataSource: SelfStudyDataSource

    init(remoteDataSource: SelfStudyDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchSelfStudyTeacher(date: String) -> Single<SelfStudyEntity> {
        return remoteDataSource.fetchSelfStudyTeacher(date: date)
            .map(SelfStudyTeacherDTO.self)
            .map { $0.toDomain() }
    }
    
}
