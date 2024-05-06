//
//  COGSInformationUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 29.04.2024.
//

import Foundation
import Domain
import RxSwift

final class COGSInformationUseCase: Domain.COGSInformationUseCase {
    
    private let informationCOGSNetwork: Domain.COGSInformationNetwork
    
    init(informationCOGSNetwork: Domain.COGSInformationNetwork) {
        self.informationCOGSNetwork = informationCOGSNetwork
    }
    
    func getCOGSInformation(_ settingsType: String) -> Observable<CostOfGoodsSettingsModel> {
        return informationCOGSNetwork.getCOGSInformation()
            .compactMap { cogs in
                cogs.filter { $0.settingsType == settingsType}
            }.compactMap { cogs in
                cogs.first?.data
            }
    }
    
}
