//
//  UpdatePasswordNetwork.swift
//  Domain
//
//  Created by George Churikov on 06.06.2024.
//

import Foundation
import RxSwift

public protocol UpdatePasswordNetwork {
    func updatePassword(_ data: UpdatePasswordRequestModel) -> Observable<StatusDTO>
}
