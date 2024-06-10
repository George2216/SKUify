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
    // Realm use case
    private let currencyUseCase: Domain.CurrencyUseCase
    
    init(
        network: Domain.UserDataNetwork,
        currencyUseCase: Domain.CurrencyUseCase
    ) {
        self.network = network
        self.currencyUseCase = currencyUseCase
    }
    
    func getUserData() -> Observable<UserMainDTO> {
        network.getUserData()
    }
    
    func updateUserData(data: UserRequestModel) -> Observable<Void> {
        network.updateUserData(data: data)
            .mapToVoid()
    }
    
    func updateCompanyInformation(data: Domain.CompanyInformationRequestModel) -> Observable<Void> {
        network.updateCompanyInformation(data: data)
            .mapToVoid()
    }
    
    // Update in realm
    func updateCurrency() -> Observable<Void> {
        getUserData()
            .flatMap(weak: self) { owner, data in
                owner.currencyUseCase
                    .updateCurrency(data.user.currency)
            }
    }
    
    // Update in network
    func updateCurrency(_ data: Domain.CurrencyRequestModel) -> Observable<Void> {
        network.updateCurrency(data)
        // Save to realm
            .flatMap(weak: self) { owner, data in
                owner.currencyUseCase
                    .updateCurrency(data.user.currency)
            }
            .mapToVoid()
    }
    
}
