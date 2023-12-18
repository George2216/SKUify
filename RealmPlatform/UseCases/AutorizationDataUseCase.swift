//
//  AutorizationDataUseCase.swift
//  RealmPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Domain
import RxSwift
import Realm
import RealmSwift

final class AuthorizationDataUseCase<Repository>: Domain.AuthorizationDataUseCase where Repository: AbstractRepository, Repository.T == AuthorizationData {
    
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }
    
    func getAuthorizationData() -> Observable<AuthorizationData?> {
        return repository
            .queryAll()
            .map({ $0.last})
    }

    func saveAuthorizationData(data: AuthorizationData) -> Observable<Void> {
        return repository
            .saveEntity(entity: data)
    }
    
    func delete(data: AuthorizationData) -> Observable<Void> {
        return repository
            .deleteEntity(entity: data)
    }
    
}
