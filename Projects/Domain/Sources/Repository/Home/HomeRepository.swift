import Foundation

import RxSwift

import Core

public protocol HomeRepository {
    func fetchApplyStatus() -> Single<HomeApplyStatusEntity>
}
