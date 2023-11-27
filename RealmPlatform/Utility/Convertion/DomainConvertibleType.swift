//
//  DomainConvertibleType.swift
//  RealmPlatform
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation
import RealmSwift

protocol DomainConvertibleType {
    associatedtype DomainType

    func asDomain() -> DomainType
}


