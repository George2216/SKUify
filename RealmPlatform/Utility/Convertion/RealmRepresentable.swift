//
//  RealmRepresentable.swift
//  RealmPlatform
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation
import RealmSwift

protocol RealmRepresentable where Self: Equatable {
    associatedtype RealmType: DomainConvertibleType

    var uid: String { get }
    
    func asRealm() -> RealmType
}
