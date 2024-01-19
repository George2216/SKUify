//
//  SettingsViewModel.swift
//  SKUify
//
//  Created by George Churikov on 01.12.2023.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class SettingsViewModel: ViewModelProtocol {
    private let disposeBag = DisposeBag()

    private let logoutTrigger = PublishSubject<Void>()
    
    // Dependencies
    private let navigator: SettingsNavigatorProtocol
    
    // Use case storage
    private let loginUseCase: LoginStateWriteUseCase
    private let appVersionUseCase: AppVersionUseCase
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    
    init(
        useCases: SettingsUseCases,
        navigator: SettingsNavigatorProtocol
    ) {
        self.navigator = navigator
        loginUseCase = useCases.makeLoginStateUseCase()
        appVersionUseCase = useCases.makeAppVersionUseCase()
        subscribeOnLogout()
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            defaultSettingsButtonConfigs: makeDefaultSettingsButtonConfigs(),
            logoutButtonConfig: makeLogoutButtonConfig(),
            appVersionLabelText: makeAppVersionLabelText()
        )
    }
    
    private func makeDefaultSettingsButtonConfigs() -> Driver<[DefaultSettingsButton.Config]> {
        .just(
            [
                .init(
                    title: "Profile",
                    action: { [weak self] in
                        guard let self else { return }
                        self.navigator.toProfile()
                    }
                ),
                .init(
                    title: "Company Information",
                    action: {
                        
                    }
                ),
                .init(
                    title: "Security",
                    action: {
                        
                    }
                ),
                .init(
                    title: "Notification Settings",
                    action: {
                        
                    }
                ),
                
            ]
        )
    }
    
    private func makeLogoutButtonConfig() -> Driver<LogoutSettingsButton.Config> {
        .just(
            .init(
                title: "Logout",
                action: { [weak self] in
                    guard let self else { return }
                    self.logoutTrigger.onNext(())
                }
            )
        )
    }
    
    private func makeAppVersionLabelText() -> Driver<String?> {
        appVersionUseCase
            .getAppVersion()
            .map({ version in
                "App version \(version ?? "unavailable")"
            })
            .asDriverOnErrorJustComplete()
    }
    
    private func subscribeOnLogout() {
        logoutTrigger.flatMapFirst(weak: self) { owner, _ in
            owner.loginUseCase.logout()
        }
        .subscribe()
        .disposed(by: disposeBag)
    }
    
}


extension SettingsViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let defaultSettingsButtonConfigs: Driver<[DefaultSettingsButton.Config]>
        let logoutButtonConfig: Driver<LogoutSettingsButton.Config>
        let appVersionLabelText: Driver<String?>
    }
    
}
