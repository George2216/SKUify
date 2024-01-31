//
//  UserDataNetwork.swift
//  Domain
//
//  Created by George Churikov on 19.01.2024.
//

import Foundation
import RxSwift

public protocol UserDataNetwork {
    func getUserData() -> Observable<UserMainDTO>
    func updateUserData(data: Domain.UserRequestModel) -> Observable<UserMainDTO>
}
