//
//  RMTokens.swift
//  RealmPlatform
//
//  Created by George Churikov on 15.12.2023.
//

import Domain
import Realm
import RealmSwift

// RMTokens
class RMTokens: Object {
    @Persisted(primaryKey: true) var _id: String = "#"

    @Persisted var accessToken: String
    @Persisted var refreshToken: String

}

extension RMTokens: DomainConvertibleType {
    func asDomain() -> Tokens {
        Tokens(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}

extension Tokens: RealmRepresentable {
    var uid: String {
        return ""
    }
    
    func asRealm() -> RMTokens {
        RMTokens.build { object in
            object.accessToken = accessToken
            object.refreshToken = refreshToken
        }
    }
}
