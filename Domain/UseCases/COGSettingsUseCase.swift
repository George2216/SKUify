//
//  COGSettingsUseCase.swift
//  Domain
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import RxSwift

public protocol COGSettingsUseCase {
    func updateProductSettings(_ data: COGSettingsRequestModel) -> Observable<Void>
}
