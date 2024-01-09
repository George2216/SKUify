//
//  MarketplacesUseCase.swift
//  RealmPlatform
//
//  Created by George Churikov on 08.01.2024.
//

import Foundation
import Domain
import RxSwift

final class MarketplacesUseCase<Repository>: Domain.MarketplacesUseCase where Repository: AbstractRepository, Repository.T == Domain.MarketplaceDTO {
       
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    public func saveMarketplaces(marketplaces: [MarketplaceDTO]) -> Observable<Void> {
        repository
            .saveEntities(entities: marketplaces)
    }
    
    func removeMarketplaces() -> Observable<Void> {
        repository
            .deleteAllObjects(type: MarketplaceDTO.self)
    }
    
    func getMarketplaces() -> Observable<[MarketplaceDTO]> {
        repository
            .queryAll()
    }
    
    func getMarketplaceById(id: String) -> Observable<MarketplaceDTO> {
         return getMarketplaces()
             .flatMapLatest { marketplaces -> Observable<MarketplaceDTO> in
                 guard let marketplace = marketplaces.first(where: { $0.marketplaceId == id }) else {
                     return Observable.error(CustomError.novValue)
                 }
                 return Observable.just(marketplace)
             }
     }
    
    private enum CustomError: Error {
        case novValue

    }
    
}


