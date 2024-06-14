//
//  UserDataNetwork.swift
//  Domain
//
//  Created by George Churikov on 19.01.2024.
//

import Foundation
import RxSwift

public protocol UserDataNetwork {
    func getUserData() -> Observable<UserDTO>
    func updateUserData(data: Domain.UserRequestModel) -> Observable<UserDTO>
    func updateCompanyInformation(data: Domain.CompanyInformationRequestModel) -> Observable<UserDTO>
    func updateCurrency(_ data: CurrencyRequestModel) -> Observable<UserDTO>
}
