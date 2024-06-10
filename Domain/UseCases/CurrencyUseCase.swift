//
//  CurrencyUseCase.swift
//  Domain
//
//  Created by George Churikov on 10.06.2024.
//

import Foundation
import RxSwift

public protocol CurrencyUseCase: CurrencyReadUseCase, CurrencyWhriteUseCase { }

public protocol CurrencyReadUseCase {
    func getCurrency() -> Observable<String>
}

public protocol CurrencyWhriteUseCase {
    func updateCurrency(_ currency: String) -> Observable<Void>
}
