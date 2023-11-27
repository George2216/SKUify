//
//  RMLoginState.swift
//  RealmPlatform
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import Domain
import RealmSwift

// RMIsLoggedUser
class RMLoginState: Object {
    @Persisted(primaryKey: true) var _id: String = "#"

    @Persisted var isLogged: Bool
}

extension RMLoginState: DomainConvertibleType {
    func asDomain() -> LoginState {
        LoginState(isLogged: isLogged)
    }
}

extension LoginState: RealmRepresentable {
    var uid: String {
        return ""
    }
    
    func asRealm() -> RMLoginState {
        RMLoginState.build { object in
            object.isLogged = isLogged
        }
    }
}
