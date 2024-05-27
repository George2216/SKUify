//
//  ExpensesCategoriesDataUseCase.swift
//  Domain
//
//  Created by George Churikov on 24.05.2024.
//

import Foundation
import RxSwift

public protocol ExpensesCategoriesDataUseCase: ExpensesCategoriesReadDataUseCase, ExpensesCategoriesWriteDataUseCase {
    
}

public protocol ExpensesCategoriesReadDataUseCase {
    func getCategories() -> Observable<[ExpensesCategoryDTO]>
}

public protocol ExpensesCategoriesWriteDataUseCase {
    func updateCategories(_ categories: [ExpensesCategoryDTO]) -> Observable<Void>
    func deleteAllCategories() -> Observable<Void>
}
