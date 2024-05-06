//
//  ReplenishCOGNetwork.swift
//  Domain
//
//  Created by George Churikov on 19.04.2024.
//

import Foundation
import RxSwift

public protocol ReplenishCOGNetwork {
    func saveReplenish(_ data: ReplenishCOGRequestModel) -> Observable<[OnlyIdDTO]>
}
