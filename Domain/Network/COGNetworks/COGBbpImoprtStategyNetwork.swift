//
//  COGBbpImoprtStategyNetwork.swift
//  Domain
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import RxSwift

public protocol COGBbpImoprtStategyNetwork {
    func updateBBPImportStrategy(_ data: BbpImoprtStategyRequestModel) -> Observable<InventoryBuyBotImportsDTO>
}
