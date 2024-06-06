//
//  UpdatePasswordUseCase.swift
//  Domain
//
//  Created by George Churikov on 06.06.2024.
//

import Foundation
import RxSwift

public protocol UpdatePasswordUseCase {
    func updatePassword(_ data: UpdatePasswordRequestModel) -> Observable<Void>
}

