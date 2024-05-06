//
//  COGBbpImoprtStategyUseCase.swift
//  Domain
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import RxSwift

public protocol COGBbpImoprtStategyUseCase {
    func updateBBPImportStrategy(_ data: BbpImoprtStategyRequestModel) -> Observable<Void>

}
