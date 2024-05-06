//
//  COGSettingsUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import Domain
import RxSwift

final class COGSettingsUseCase: Domain.COGSettingsUseCase {
    
    private let settingsNetwork: Domain.COGSettingsNetwork
    
    init(settingsNetwork: Domain.COGSettingsNetwork) {
        self.settingsNetwork = settingsNetwork
    }
    
    func updateProductSettings(_ data: COGSettingsRequestModel) -> Observable<Void> {
        settingsNetwork
            .updateProductSettings(data)
            .mapToVoid()
    }
    
}
