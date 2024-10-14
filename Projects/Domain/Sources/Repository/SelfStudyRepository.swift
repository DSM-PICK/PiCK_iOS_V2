import Foundation

import RxSwift

public protocol SelfStudyRepository {
    func fetchSelfStudyTeacher(date: String) -> Single<SelfStudyEntity>
}
