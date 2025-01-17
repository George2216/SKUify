//
//  UserDataUseCase.swift
//  Domain
//
//  Created by George Churikov on 19.01.2024.
//

import Foundation
import RxSwift

public protocol UserDataUseCase: UserDataCurrencyLoadUseCase, UserDataCurrencyUpdateUseCase {
    func getUserData() -> Observable<UserDTO>
    func updateUserData(data: UserRequestModel) -> Observable<Void>
    func updateCompanyInformation(data: CompanyInformationRequestModel) -> Observable<Void>
}

// Update in Realm
public protocol UserDataCurrencyLoadUseCase {
    func updateCurrency() -> Observable<Void>
}

// Update in network, after that in Realm
public protocol UserDataCurrencyUpdateUseCase {
    func updateCurrency(_ data: CurrencyRequestModel) -> Observable<Void>
}
