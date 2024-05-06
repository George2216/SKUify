//
//  BreakEvenPointUseCase.swift
//  Domain
//
//  Created by George Churikov on 11.04.2024.
//

import Foundation
import RxSwift

public protocol BreakEvenPointUseCase {
    func getSalesBreakEvenPoint(_ data: COGBreakEvenRequestModel) -> Observable<BreakEvenPointDTO>
    func getInventoryBreakEvenPoint(_ data: COGBreakEvenRequestModel) -> Observable<BreakEvenPointDTO>
}
