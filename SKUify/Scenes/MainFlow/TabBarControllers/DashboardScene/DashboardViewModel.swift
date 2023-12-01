//
//  DashboardViewModel.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

final class DashboardViewModel: ViewModelProtocol {
    
    // Dependencies
    private let navigator: DashboardNavigatorProtocol
    
    // Use case storage
    
    
    private let showCurrencyPopover = PublishSubject<CGPoint>()
    private let showCalendarPopover = PublishSubject<CGPoint>()

    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: DashboardUseCases,
        navigator: DashboardNavigatorProtocol
    ) {
        self.navigator = navigator
        
    }
    
    // MARK: -  Make bar button item configs
    
    private func makeSettingsBarButtonConfig() -> Driver<DefaultBarButtonItem.Config> {
        .just(
            .init(
                style: .image(.settings),
                actionType: .base({
                    
                })
            )
        )
    }
    
    private func makeCurrencyBarButtonConfig() -> Driver<DefaultBarButtonItem.Config> {
        .just(
            .init(
                style: .image(.currency),
                actionType: .popUp({ center in
                    self.showCurrencyPopover.onNext(center)
                })
            )
        )
    }
    
    private func makeNotificationBarButtonConfig() -> Driver<DefaultBarButtonItem.Config> {
        .just(
            .init(
                style: .image(.notification),
                actionType: .base({
                    
                })
            )
        )
    }
    
    private func makeTitleImageBarButtonConfig() -> Driver<DefaultBarButtonItem.Config> {
        .just(
            .init(
                style: .image(.titleImage)
            )
        )
    }
    
    private func makeFilterByDatePopoverButtonConfig() -> Driver<PopoverButton.Config> {
        .just(
            .init(
                title: "Filter by date",
                action: { [weak self] center in
                    guard let self else { return }
                    self.showCalendarPopover.onNext(center)
                }
            )
        )
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            settingsBarButtonConfig: makeSettingsBarButtonConfig(),
            currencyBarButtonConfig: makeCurrencyBarButtonConfig(),
            notificationBarButtonConfig: makeNotificationBarButtonConfig(),
            titleImageBarButtonConfig: makeTitleImageBarButtonConfig(),
            filterByDatePopoverButtonConfig: makeFilterByDatePopoverButtonConfig(),
            showCurrencyPopover: showCurrencyPopover.asDriverOnErrorJustComplete(),
            showCalendarPopover: showCalendarPopover.asDriverOnErrorJustComplete()
        )
    }
    
    struct Input {
        
    }
    
    struct Output {
        let settingsBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let currencyBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let notificationBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let titleImageBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        
        let filterByDatePopoverButtonConfig: Driver<PopoverButton.Config>
        
        let showCurrencyPopover: Driver<CGPoint>
        let showCalendarPopover: Driver<CGPoint>
    }
    
}



