//
//  RMExpensesCategory.swift
//  RealmPlatform
//
//  Created by George Churikov on 24.05.2024.
//

import Foundation
import Domain
import RealmSwift

// RMExpensesCategory
class RMExpensesCategory: Object {
    @Persisted var id: Int
    @Persisted var name: String
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

extension RMExpensesCategory: DomainConvertibleType {
    func asDomain() -> ExpensesCategoryDTO {
        .init(
            id: id,
            name: name
        )
    }
    
}

extension ExpensesCategoryDTO: RealmRepresentable {
    
    var uid: String {
        return "\(id)"
    }
    
    func asRealm() -> RMExpensesCategory {
        RMExpensesCategory.build { object in
            object.id = id
            object.name = name
        }
    }
    
}
