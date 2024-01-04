//
//  RMAuthorizationData.swift
//  RealmPlatform
//
//  Created by George Churikov on 07.12.2023.
//

import Domain
import RealmSwift
import Realm

// RMAuthorizationData
class RMAuthorizationData: Object {
    @Persisted(primaryKey: true) var _id: String = "#"

    @Persisted var email: String
    @Persisted var password: String
}

extension RMAuthorizationData: DomainConvertibleType {
    func asDomain() -> AuthorizationData {
        AuthorizationData(
            email: email,
            password: password
        )
    }
}

extension AuthorizationData: RealmRepresentable {
    var uid: String {
        return ""
    }
    
    func asRealm() -> RMAuthorizationData {
        RMAuthorizationData.build { object in
            object.email = email
            object.password = password
        }
    }
}
