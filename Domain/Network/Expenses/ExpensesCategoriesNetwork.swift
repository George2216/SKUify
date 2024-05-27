//
//  ExpensesCategoriesNetwork.swift
//  Domain
//
//  Created by George Churikov on 13.05.2024.
//

import Foundation
import RxSwift

public protocol ExpensesCategoriesNetwork {
    func getCategories() -> Observable<[ExpensesCategoryDTO]>
}
