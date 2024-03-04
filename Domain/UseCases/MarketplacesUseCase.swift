//
//  MarketplacesUseCase.swift
//  Domain
//
//  Created by George Churikov on 08.01.2024.
//

import Foundation
import RxSwift

public protocol MarketplacesUseCase: MarketplacesReadUseCase, MarketplacesWriteUseCase {}

public protocol MarketplacesReadUseCase {
    func getMarketplaces() -> Observable<[MarketplaceDTO]>
    func getMarketplaceById(id: String) -> Observable<MarketplaceDTO>
    func getMarketplaceByCountryCode(_ countryCode: String) -> Observable<MarketplaceDTO>
}

public protocol MarketplacesWriteUseCase {
    func saveMarketplaces(marketplaces: [MarketplaceDTO]) -> Observable<Void>
    func removeMarketplaces() -> Observable<Void>
}
