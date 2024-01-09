//
//  UserIdUseCase.swift
//  RealmPlatform
//
//  Created by George Churikov on 03.01.2024.
//

import Foundation
import Domain
import RxSwift

final class UserIdUseCase<Repository>: Domain.UserIdUseCase where Repository: AbstractRepository, Repository.T == Domain.UserId {
       
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func getUserId() -> Observable<Int> {
        repository
            .queryAll()
            .compactMap({ $0.last })
            .map({ $0.userId})
    }
    
    func saveUserId(userId: Int) -> Observable<Void> {
        repository
            .saveEntity(
                entity: UserId(userId: userId)
            )
    }
    
    func removeUserId() -> Observable<Void> {
        return repository
            .deleteAllObjects(type: UserId.self)
    }
    
}


