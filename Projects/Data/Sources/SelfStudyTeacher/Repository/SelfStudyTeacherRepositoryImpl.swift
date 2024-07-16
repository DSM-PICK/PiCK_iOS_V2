import Foundation

import RxSwift

import Domain

class SelfStudyTeacherRepositoryImpl: SelfStudyRepository {
    
    let remoteDataSource = SelfStudyTeacherDataSource.shared
    
    func fetchSelfStudyTeacher(date: String) -> Single<SelfStudyTeacherEntity> {
        return remoteDataSource.fetchSelfStudyTeacher(date: date)
            .map(SelfStudyTeacherDTO.self)
            .map { $0.toDomain() }
    }
    
}
