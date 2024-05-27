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
    
    // DI
    private let appNavigator: AppNavigatorProtocol
    // Use cases
    private let loginStateUseCase: LoginStateUseCase
    private let expensesCategoriesUseCase: Domain.ExpensesCategoriesUseCase
    
    private let mandatoryDataActivityTraker = ActivityTracker()
    private let mandatoryDataErrorTraker = ErrorTracker()
    
    init(
        appNavigator: AppNavigatorProtocol,
        useCases: AppManagerUseCases
    ) {
        self.appNavigator = appNavigator
        
        self.loginStateUseCase = useCases
            .makeLoginStateUseCase()
        self.expensesCategoriesUseCase = useCases
            .makeExpensesCategoriesUseCase()
        
        appEntryPoint()
        subscribeToMandatoryDataActivityTracker()
    }
    
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
            .flatMap(weak: self) { owner, _ in
                owner.loadMantadoryData()
            }
            .flatMapFirst(weak: self){ owner, _ in
                owner.toMainFlow()
            }
            .drive()
            .disposed(by: disposeBag)
        
    }
    
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
    
    
    private func loadMantadoryData() -> Driver<Void> {
        expensesCategoriesUseCase
            .updateCategories()
            .trackActivity(mandatoryDataActivityTraker)
            .trackError(mandatoryDataErrorTraker)
            .asDriverOnErrorJustComplete()
      // and other mantadory data
    }
    
}
