//
//  ReplenishCOGUseCase.swift
//  Domain
//
//  Created by George Churikov on 19.04.2024.
//

import Foundation
import RxSwift

public protocol ReplenishCOGUseCase {
    func saveReplenish(_ data: ReplenishCOGRequestModel) -> Observable<Void>
}
