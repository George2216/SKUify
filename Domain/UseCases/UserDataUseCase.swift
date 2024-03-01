//
//  UserDataUseCase.swift
//  Domain
//
//  Created by George Churikov on 19.01.2024.
//

import Foundation
import RxSwift

public protocol UserDataUseCase {
    func getUserData() -> Observable<UserMainDTO>
    func updateUserData(data: UserRequestModel) -> Observable<Void>
    func updateCompanyInformation(data: CompanyInformationRequestModel) -> Observable<Void>
}
