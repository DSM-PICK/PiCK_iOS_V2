import Foundation

import RxSwift

public class FetchDetailProfileUseCase {
    let repository: ProfileRepository
    
    public init(repository: ProfileRepository) {
        self.repository = repository
    }
    
    public func execute() -> Single<DetailProfileEntity> {
        return repository.fetchDetailProfile()
    }
    
}
