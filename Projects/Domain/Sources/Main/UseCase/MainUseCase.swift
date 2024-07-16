import Foundation

import RxSwift
 
import Core

public class FetchMainUseCase {
    let repository: MainRepository
    
    public init(repository: MainRepository) {
        self.repository = repository
    }
    
    public func execute() -> Single<MainEntity?> {
        return repository.fetchMainData()
    }
    
}
