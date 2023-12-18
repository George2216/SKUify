//
//  LoginNetwork.swift
//  Domain
//
//  Created by George Churikov on 08.12.2023.
//

import Foundation
import RxSwift

public protocol LoginNetwork {
    func login(
        email: String,
        password: String
    ) -> Observable<LoginDTO>
}
