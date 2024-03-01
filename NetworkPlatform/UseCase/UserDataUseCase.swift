//
//  UserDataUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 19.01.2024.
//

import Foundation
import Domain
import RxSwift
import RxExtensions

final class UserDataUseCase: Domain.UserDataUseCase {
    
    private let network: Domain.UserDataNetwork

    init(network: Domain.UserDataNetwork) {
        self.network = network
    }
    
    func getUserData() -> Observable<UserMainDTO> {
        network.getUserData()
    }
    
    func updateUserData(data: UserRequestModel) -> Observable<Void> {
        network.updateUserData(data: data)
            .map { _ in }
    }
    
    func updateCompanyInformation(data: Domain.CompanyInformationRequestModel) -> Observable<Void> {
        network.updateCompanyInformation(data: data)
            .map { _ in }
    }
    
}
