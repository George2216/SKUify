//
//  CurrencyUseCase.swift
//  RealmPlatform
//
//  Created by George Churikov on 10.06.2024.
//

import Foundation
import Domain
import RxSwift

final class CurrencyUseCase<Repository>: Domain.CurrencyUseCase where Repository: AbstractRepository, Repository.T == Domain.Currency {
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func getCurrency() -> Observable<String> {
        repository.queryAll()
            .compactMap { $0.first?.currency }
    }
   
    func updateCurrency(_ currency: String) -> Observable<Void> {
        repository
            .saveEntity(entity: Currency(currency: currency))
    }
    
}


