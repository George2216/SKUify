//
//  LoginStateUseCase.swift
//  RealmPlatform
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import Domain
import RxSwift

final class LoginStateUseCase<Repository>: Domain.LoginStateUseCase where Repository: AbstractRepository, Repository.T == Domain.LoginState {
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    public func login() -> Observable<Void> {
        repository
            .saveEntity(
                entity: LoginState(isLogged: true)
            )
    }
    
    public func logout() -> Observable<Void> {
        return repository
            .saveEntity(
                entity: LoginState(isLogged: false)
            )
    }
    
    public func isLogged() -> Observable<Bool> {
        return repository
            .queryAll()
            .map({ $0.last })
            .map { model in
                model?.isLogged ?? false
            }
    }
    
}


