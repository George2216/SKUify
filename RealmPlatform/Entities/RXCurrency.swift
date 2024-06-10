//
//  RXCurrency.swift
//  RealmPlatform
//
//  Created by George Churikov on 10.06.2024.
//

import Foundation
import Domain
import Realm
import RealmSwift

class RXCurrency: Object {
    @Persisted(primaryKey: true) var _id: String = "#"
    @Persisted var currency: String
    
}

extension RXCurrency: DomainConvertibleType {
    func asDomain() -> Currency {
        Currency(currency: currency)
    }
    
}

extension Currency: RealmRepresentable {
    var uid: String {
        return ""
    }
    
    func asRealm() -> RXCurrency {
        RXCurrency.build { object in
            object.currency = currency
        }
    }
    
}
