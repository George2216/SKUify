//
//  ResetPasswordNetwork.swift
//  Domain
//
//  Created by George Churikov on 10.06.2024.
//

import Foundation
import RxSwift

public protocol ResetPasswordNetwork {
    func resetPassword(_ data: ResetPasswordRequestModel) -> Observable<StatusDTO>
}
