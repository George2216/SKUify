//
//  UpdatePassworUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 06.06.2024.
//

import Foundation
import Domain
import RxSwift

final class UpdatePasswordUseCase: Domain.UpdatePasswordUseCase {
    
    private let network: Domain.UpdatePasswordNetwork

    init(network: Domain.UpdatePasswordNetwork) {
        self.network = network
    }
    
    func updatePassword(_ data: UpdatePasswordRequestModel) -> Observable<Void> {
        network
            .updatePassword(data)
            .mapToVoid()
    }
    
}
