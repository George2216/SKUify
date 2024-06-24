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
    private let userDataUseCase: Domain.UserDataCurrencyLoadUseCase
    
    private let activityTracker = ActivityTracker()
    private let errorTracker = ErrorTracker()

    init(
        appNavigator: AppNavigatorProtocol,
        useCases: AppManagerUseCases
    ) {
        self.appNavigator = appNavigator
        
        self.loginStateUseCase = useCases
            .makeLoginStateUseCase()
        self.expensesCategoriesUseCase = useCases
            .makeExpensesCategoriesUseCase()
        self.userDataUseCase = useCases.makeUserDataUseCase()
        
        appEntryPoint()
        subscribeToMandatoryDataActivityTracker()
        subscribeOnMantadoryDataErrorTraker()
    }
    
    private func subscribeToMandatoryDataActivityTracker() {
        activityTracker
            .drive(with: self) { owner, isShow in
                owner.appNavigator
                    .showFakeLuncher(isShow: isShow)
            }
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnMantadoryDataErrorTraker() {
        errorTracker
            .asBannerInput()
            .drive(with: self) { owner, input in
                owner.appNavigator
                    .showBanner(input: input)
            }
            .disposed(by: disposeBag)
    }
    
    private func appEntryPoint() {
        checkUserLoggedIn()
            .filterEqual(false)
            .flatMapFirst(weak: self) { owner, _ in
                owner.toLoginFlow()
            }
            .drive()
            .disposed(by: disposeBag)
        
        checkUserLoggedIn()
            .filterEqual(true)
            .flatMap(weak: self) { owner, _ in
                owner.loadMantadoryData()
            }
            .flatMapFirst(weak: self) { owner, _ in
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
        Observable.combineLatest(
            expensesCategoriesUseCase.updateCategories(),
            userDataUseCase.updateCurrency()
        )
        .mapToVoid()
        .trackActivity(activityTracker)
        .trackError(errorTracker)
        .asDriverOnErrorJustComplete()
        // and other mantadory data
    }
    
}
