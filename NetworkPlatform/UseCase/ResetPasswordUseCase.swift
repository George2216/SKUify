//
//  ResetPasswordUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 10.06.2024.
//

import Foundation
import Domain
import RxSwift

final class ResetPasswordUseCase: Domain.ResetPasswordUseCase {
    
    private let network: Domain.ResetPasswordNetwork

    init(
        network: Domain.ResetPasswordNetwork
    ) {
        self.network = network
    }
    
    func resetPassword(_ data: ResetPasswordRequestModel) -> Observable<Void> {
        network
            .resetPassword(data)
            .mapToVoid()
    }
   
}
