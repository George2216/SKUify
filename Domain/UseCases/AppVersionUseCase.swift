//
//  AppVersionUseCase.swift
//  Domain
//
//  Created by George Churikov on 01.12.2023.
//

import Foundation
import RxSwift

public protocol AppVersionUseCase {
    func getAppVersion() -> Observable<String?>
}

