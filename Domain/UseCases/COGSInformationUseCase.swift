//
//  COGSInformationUseCase.swift
//  Domain
//
//  Created by George Churikov on 29.04.2024.
//

import Foundation
import RxSwift

public protocol COGSInformationUseCase {
    func getCOGSInformation(_ settingsType: String) -> Observable<CostOfGoodsSettingsModel>
}

