//
//  COGUseCase.swift
//  Domain
//
//  Created by George Churikov on 16.04.2024.
//

import Foundation
import RxSwift

public protocol COGUseCase {
    func updateSalesCOG(_ data: COGSalesRequestModel) -> Observable<Void>
    func updateInventoryCOG(_ data: COGInventoryRequestModel) -> Observable<Void>

}
