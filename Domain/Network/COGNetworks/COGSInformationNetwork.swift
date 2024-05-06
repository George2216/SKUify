//
//  COGSInformationNetwork.swift
//  Domain
//
//  Created by George Churikov on 29.04.2024.
//

import Foundation
import RxSwift

public protocol COGSInformationNetwork {
    func getCOGSInformation() -> Observable<[CostOfGoodsSettingsMainDTO]>
}
