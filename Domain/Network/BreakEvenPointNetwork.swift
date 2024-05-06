//
//  BreakEvenPointNetwork.swift
//  Domain
//
//  Created by George Churikov on 11.04.2024.
//

import Foundation
import RxSwift

public protocol BreakEvenPointNetwork {
    func getBreakEvenPoint(_ data: COGBreakEvenRequestModel) -> Observable<BreakEvenPointDTO>
}
