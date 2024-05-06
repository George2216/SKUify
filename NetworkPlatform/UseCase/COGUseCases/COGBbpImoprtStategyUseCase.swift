//
//  COGBbpImoprtStategyUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 06.05.2024.
//

import Foundation
import Domain
import RxSwift

final class COGBbpImoprtStategyUseCase: Domain.COGBbpImoprtStategyUseCase {
    
    private let imoprtStategyNetwork: Domain.COGBbpImoprtStategyNetwork
    
    init(imoprtStategyNetwork: Domain.COGBbpImoprtStategyNetwork) {
        self.imoprtStategyNetwork = imoprtStategyNetwork
    }
    
    func updateBBPImportStrategy(_ data: BbpImoprtStategyRequestModel) -> Observable<Void> {
        imoprtStategyNetwork
            .updateBBPImportStrategy(data)
            .mapToVoid()
    }
    
}
