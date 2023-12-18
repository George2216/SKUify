//
//  AppManager.swift
//  SKUify
//
//  Created by George Churikov on 17.11.2023.
//

import Foundation
import RxSwift
import RxCocoa
import Domain
import RxExtensions

final class AppManager {
    private let disposeBag = DisposeBag()
    
    private let appNavigator: AppNavigatorProtocol
    
    private let mandatoryDataActivityTraker = ActivityTracker()
    private let mandatoryDataErrorTraker = ErrorTracker()
    
    private let loginStateUseCase: LoginStateUseCase
    
    init(
        appNavigator: AppNavigatorProtocol,
        useCases: AppManagerUseCases
    ) {
        self.appNavigator = appNavigator
        
        self.loginStateUseCase = useCases
            .makeLoginStateUseCase()
        
        
        appEntryPoint()
        subscribeToMandatoryDataActivityTracker()
//        subscribeToMandatoryDataErrorTracker()
    }
    
//    private func subscribeToMandatoryDataErrorTracker() {
//        mandatoryDataErrorTraker
//            .map({ $0.localizedDescription })
//            .map({ BannerView.Input(text: $0, style: .error) })
//            .do(onNext: BannerViewManager.shared.showBanner)
//            .drive()
//            .disposed(by: disposeBag)
//    }
    
    private func subscribeToMandatoryDataActivityTracker() {
        mandatoryDataActivityTraker
            .drive(with: self) { owner, isShow in
                owner.appNavigator
                    .showFakeLuncher(isShow: isShow)
            }
            .disposed(by: disposeBag)
    }
    
    private func appEntryPoint() {
        checkUserLoggedIn()
            .filterEqual(false)
            .flatMapFirst(weak: self, selector: { owner, _ in
                owner.toLoginFlow()
            })
            .drive()
            .disposed(by: disposeBag)
        
        checkUserLoggedIn()
            .filterEqual(true)
            .flatMapFirst(weak: self, selector: { owner, _ in
                owner.toMainFlow()
            })
            .drive()
            .disposed(by: disposeBag)
        
        
//        checkUserLoggedIn()
//            .filterEqual(true)
//            .flatMapFirst(weak: self, selector: { owner, _ in
//                owner.fetchMandatoryData()
//            })
//            .drive()
//            .disposed(by: disposeBag)
    }
    
    
//    private func fetchMandatoryData() {
//        mandatoryDataUseCase
//            .fetchMandatoryData()
//            .trackActivity(mandatoryDataActivityTraker)
//            .trackError(mandatoryDataErrorTraker)
//            .asDriverOnErrorJustComplete()
//            .drive(onNext: appNavigator.toMainFlow)
//            .disposed(by: disposeBag)
//    }
    
    private func toLoginFlow() -> Driver<Void> {
        .just(appNavigator.toLoginFlow())
    }
    
    
    private func toMainFlow() -> Driver<Void> {
        .just(appNavigator.toMainFlow())
        
    }
    private func checkUserLoggedIn() -> Driver<Bool> {
        loginStateUseCase
            .isLogged()
            .asDriverOnErrorJustComplete()
    }
    
}
