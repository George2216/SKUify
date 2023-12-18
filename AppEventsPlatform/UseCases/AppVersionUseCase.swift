//
//  AppVersionUseCase.swift
//  AppEventsPlatform
//
//  Created by George Churikov on 01.12.2023.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class AppVersionUseCase: Domain.AppVersionUseCase {
    
    func getAppVersion() -> Observable<String?> {
        .just(
            Bundle
                .main
                .infoDictionary?["CFBundleShortVersionString"]
            as? String
        )
    }
    
}
