//
//  TokensUseCase.swift
//  RealmPlatform
//
//  Created by George Churikov on 15.12.2023.
//

import Domain
import RxSwift
import Realm
import RealmSwift
import RxExtensions

final class TokensUseCase<Repository>: Domain.TokensUseCase where Repository: AbstractRepository, Repository.T == Tokens {
    
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }
    
    func getTokens() -> Observable<Tokens?> {
        return repository
            .queryAll()
            .map({ $0.last})
    }

    func saveTokens(data: Tokens) -> Observable<Void> {
        return repository
            .saveEntity(entity: data)
    }
    
    func updateAccessToken(_ accessToken: String) -> Observable<Void> {
        return getTokens()
            .flatMap(weak: self) { owner, tokens in
                let updatetTokens = Tokens(
                    accessToken: accessToken,
                    refreshToken: tokens?.refreshToken ?? ""
                )
                return owner.saveTokens(data: updatetTokens)
            }
            .mapToVoid()
    }
    
    func updateRefreshToken(_ refreshToken: String) -> Observable<Void> {
        return getTokens()
            .flatMap(weak: self) { owner, tokens in
                let updatetTokens = Tokens(
                    accessToken: tokens?.accessToken ?? "",
                    refreshToken: refreshToken
                )
                return owner.saveTokens(data: updatetTokens)
            }
            .mapToVoid()
    }
    
    func deleteTokens() -> Observable<Void> {
        return repository
            .deleteAllObjects(type: Tokens.self)
    }
    
}
