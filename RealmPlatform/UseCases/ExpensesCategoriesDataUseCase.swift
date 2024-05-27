//
//  ExpensesCategoriesDataUseCase.swift
//  RealmPlatform
//
//  Created by George Churikov on 24.05.2024.
//

import Foundation
import Domain
import RxSwift

final class ExpensesCategoriesDataUseCase<Repository>: Domain.ExpensesCategoriesDataUseCase where Repository: AbstractRepository, Repository.T == Domain.ExpensesCategoryDTO {
  
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    // MARK: - ExpensesCategoriesReadDataUseCase
    
    func getCategories() -> Observable<[ExpensesCategoryDTO]> {
        repository
            .queryAll()
    }

    // MARK: - ExpensesCategoriesWriteDataUseCase

    func updateCategories(_ categories: [ExpensesCategoryDTO]) -> Observable<Void> {
        deleteAllCategories()
            .flatMapLatest(weak: self) { owner, _ in
                return owner.saveCategories(categories)
            }
    }
    
    func deleteAllCategories() -> Observable<Void> {
        repository
            .deleteAllObjects()
    }
    
    // MARK: - Private methods
    
    private func saveCategories(_ categories: [ExpensesCategoryDTO]) -> Observable<Void> {
        repository
            .saveEntities(entities: categories)
    }
    
}


