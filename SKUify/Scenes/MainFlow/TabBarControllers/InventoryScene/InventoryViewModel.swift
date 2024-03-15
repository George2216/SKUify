//
//  InventoryViewModel.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class InventoryViewModel: ViewModelProtocol {
    
    private let tableType = BehaviorSubject<InventoryTableType>(value: .orders)

    // Dependencies
    private let navigator: InventoryNavigatorProtocol
    
    // Use case storage
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: InventoryUseCases,
        navigator: InventoryNavigatorProtocol
    ) {
        self.navigator = navigator
        
    }
    func transform(_ input: Input) -> Output {
        return Output(
            setupViewInput: makeSetupViewInput()
        )
    }
    
    
 }

// MARK: Make setup view method

extension InventoryViewModel {
    
    // Make setup view buttons configs

    private func makeOrdersButtonConfig() -> Driver<DefaultButton.Config> {
        tableType
            .asDriverOnErrorJustComplete()
            .map { type in
                DefaultButton.Config(
                    title: "Orders",
                    style: type == .orders ? .primary : .simplePrimaryText,
                    action: { [weak self] in
                        guard let self else { return }
                        self.tableType.onNext(.orders)
                    }
                )
            }
    }
    
    private func makeRefundsButtonConfig() -> Driver<DefaultButton.Config> {
        tableType
            .asDriverOnErrorJustComplete()
            .map { type in
                DefaultButton.Config(
                    title: "Buy Bot Imports",
                    style: type == .buyBotImports ? .primary : .simplePrimaryText,
                    action: { [weak self] in
                        guard let self else { return }
                        self.tableType.onNext(.buyBotImports)
                    }
                )
            }
    }
    
    private func makeSetupViewInput() -> Driver<InventorySetupView.Input> {
        .just(
            .init(
                ordersButtonConfid: makeOrdersButtonConfig(),
                buyBotImportsButtonConfid: makeRefundsButtonConfig(),
                searchTextFiestConfig: .init(
                    style: .search,
                    plaseholder: "Search inventory",
                    textObserver: { _ in }
                ),
                switchesViewInput: .init(
                    inactiveTitledSwitchInput: .init(
                        title: "Include out of stock or inactive",
                        switchState: true,
                        switchChanged: { _ in
                            
                        }),
                    noCOGsTiledSwitchInput: .init(
                        title: "No COGs",
                        switchState: true,
                        switchChanged: { _ in
                            
                        }),
                    warningsTitledSwitchInput: .init(
                        title: "Warnings only",
                        switchState: true,
                        switchChanged: { _ in
                            
                        }
                    )
                )
            )
        )
        
    }
    
}

extension InventoryViewModel {
    struct Input {
        
    }
    
    struct Output {
        let setupViewInput: Driver<InventorySetupView.Input>
    }
    
}
