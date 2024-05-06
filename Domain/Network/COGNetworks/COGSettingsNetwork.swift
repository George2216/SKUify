//
//  COGSettingsNetwork.swift
//  Domain
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import RxSwift

public protocol COGSettingsNetwork {
    func updateProductSettings(_ data: COGSettingsRequestModel) -> Observable<OnlyIdDTO>
}
