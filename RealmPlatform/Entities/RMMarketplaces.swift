//
//  RMMarketplace.swift
//  RealmPlatform
//
//  Created by George Churikov on 08.01.2024.
//

import Foundation
import Realm
import RealmSwift
import Domain

// RMMarketplace
class RMMarketplace: Object {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    
    @Persisted var marketplaceId: String
    @Persisted var endpoint: String
    @Persisted var websiteUrl: String
    @Persisted var countryCode: String
    @Persisted var country: String
    @Persisted var order: Int
    @Persisted var location: String
    @Persisted var participate: Bool
    
}

extension RMMarketplace: DomainConvertibleType {
    func asDomain() -> MarketplaceDTO {
        return MarketplaceDTO(
            marketplaceId: marketplaceId,
            endpoint: endpoint,
            websiteUrl: websiteUrl,
            countryCode: countryCode,
            country: country,
            order: order,
            location: location,
            participate: participate
        )
    }
    
}


extension MarketplaceDTO: RealmRepresentable {
    var uid: String {
        return ""
    }
    
    func asRealm() -> RMMarketplace {
        RMUserId.build { object in
            object.marketplaceId = marketplaceId
            object.endpoint = endpoint
            object.websiteUrl = websiteUrl
            object.countryCode = countryCode
            object.country = country
            object.order = order
            object.location = location
            object.participate = participate
        }
    }
    
}
