//
//  COGInventoryNetwork.swift
//  Domain
//
//  Created by George Churikov on 18.04.2024.
//

import Foundation
import RxSwift

public protocol COGInventoryNetwork {
    func updateCOG(_ data: COGInventoryRequestModel) -> Observable<EmptyDTO>
    func deleteProductSettings(id: Int) -> Observable<EmptyDTO>
}
