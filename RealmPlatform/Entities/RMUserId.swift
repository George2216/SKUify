//
//  RMUserId.swift
//  RealmPlatform
//
//  Created by George Churikov on 03.01.2024.
//

import Foundation
import Realm
import RealmSwift
import Domain

// RMUserId
class RMUserId: Object {
    @Persisted(primaryKey: true) var _id: String = "#"

    @Persisted var userId: Int
}

extension RMUserId: DomainConvertibleType {
    func asDomain() -> UserId {
        UserId(userId: userId)
    }
}

extension UserId: RealmRepresentable {
    var uid: String {
        return ""
    }
    
    func asRealm() -> RMUserId {
        RMUserId.build { object in
            object.userId = userId
        }
    }
}

