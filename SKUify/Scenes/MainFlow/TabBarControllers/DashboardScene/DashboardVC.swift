//
//  DashboardVC.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import UIKit
import RxCocoa

final class DashboardVC: BaseViewController {
    var viewModel: DashboardViewModel!
    
    // nav bar items
    private let settingsBarButtonItem = DefaultBarButtonItem()
    private let currencyBarButtonItem = DefaultBarButtonItem()
    private let notificationBarButtonItem = DefaultBarButtonItem()
    private let titleImageBarButtonItem = DefaultBarButtonItem()

    private let filterByDateButton = PopoverButton()
    
    private lazy var collectionView = DashboardCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
  
    private let calendarPopoverController = CalendarPopoverVC()
    private let currencyPopoverController = CurrencyPopoverVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.transform(.init())

        setupFilterByDateButton()
        sutupNavBarItems()
        setupCollectionView()
        
        bindToSettingsBarButtonItem(output)
        bindToCurrencyBarButtonItem(output)
        bindToNotificationBarButtonItem(output)
        bindToTitleImageBarButtonItem(output)
        bindToFilterByDateButtonConfig(output)
        bindCalendarPopover(output)
        bindCurrencyPopover(output)
        bindToCollectionView(output)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }
    
}

// MARK: - Setup views

extension DashboardVC {
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges
                .equalToSuperview()
            make.top
                .equalTo(filterByDateButton.snp.bottom)
                .offset(10)
            make.bottom
                .equalToSuperview()
        }
    }
    
    private func setupFilterByDateButton() {
        view.addSubview(filterByDateButton)
        filterByDateButton.snp.makeConstraints { make in
            make.horizontalEdges
                .equalToSuperview()
                .inset(16)
            make.height
                .equalTo(44)
            make.top.equalTo(view.safeAreaInsets.top)
                .inset(31)
        }
    }
    
    private func sutupNavBarItems() {
        navigationItem.leftBarButtonItem = titleImageBarButtonItem
        navigationItem.rightBarButtonItems = [
            notificationBarButtonItem,
            currencyBarButtonItem,
            settingsBarButtonItem
        ]
    }
    
}

// MARK: Make binding

extension DashboardVC {
    
    private func bindToCollectionView(_ output: DashboardViewModel.Output) {
        collectionView.bind(output.collectionData)
            .disposed(by: disposeBag)
    }
    
    // Bind to bar button items
    private func bindToSettingsBarButtonItem(_ output: DashboardViewModel.Output) {
        output.settingsBarButtonConfig
            .drive(settingsBarButtonItem.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToCurrencyBarButtonItem(_ output: DashboardViewModel.Output) {
        output.currencyBarButtonConfig
            .drive(currencyBarButtonItem.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToNotificationBarButtonItem(_ output: DashboardViewModel.Output) {
        output.notificationBarButtonConfig
            .drive(notificationBarButtonItem.rx.config)
            .disposed(by: disposeBag)
    }
    
    private func bindToTitleImageBarButtonItem(_ output: DashboardViewModel.Output) {
        output.titleImageBarButtonConfig
            .drive(titleImageBarButtonItem.rx.config)
            .disposed(by: disposeBag)
    }
    
    // Bind to popover button
    private func bindToFilterByDateButtonConfig(_ output: DashboardViewModel.Output) {
        output.filterByDatePopoverButtonConfig
            .drive(filterByDateButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    // Bind popover view
    private func bindCalendarPopover(_ output: DashboardViewModel.Output) {
        output.showCalendarPopover
            .withUnretained(self)
            .map { owner, center in
                PopoverManager.Input(
                    pointView: center,
                    preferredSize: .init(
                        width: owner.view.frame.width - 50,
                        height: owner.view.frame.width
                    ),
                    popoverVC: owner.calendarPopoverController
                )
            }
            .drive(rx.popover)
            .disposed(by: disposeBag)
    }
    
    private func bindCurrencyPopover(_ output: DashboardViewModel.Output) {
        output.showCurrencyPopover
            .withUnretained(self)
            .map { owner, center in
                PopoverManager.Input(
                    pointView: center,
                    preferredSize: .init(
                        width: 150,
                        height: 250
                    ),
                    popoverVC: owner.currencyPopoverController
                )
            }
            .drive(rx.popover)
            .disposed(by: disposeBag)
    }
    
}
