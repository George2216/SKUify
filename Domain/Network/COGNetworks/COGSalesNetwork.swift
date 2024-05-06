//
//  COGNetwork.swift
//  Domain
//
//  Created by George Churikov on 16.04.2024.
//

import Foundation
import RxSwift

public protocol COGNetwork {
    func updateCOG(_ data: COGSalesRequestModel) -> Observable<OnlyIdDTO>
}
