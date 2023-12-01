//
//  DashboardVC.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import UIKit

final class DashboardVC: BaseViewController {
    var viewModel: DashboardViewModel!
    
    // nav bar items
    private let settingsBarButtonItem = DefaultBarButtonItem()
    private let currencyBarButtonItem = DefaultBarButtonItem()
    private let notificationBarButtonItem = DefaultBarButtonItem()
    private let titleImageBarButtonItem = DefaultBarButtonItem()

    private let filterByDateButton = PopoverButton()
    
    private let calendarPopoverController = CalendarPopoverVC()
    private let currencyPopoverController = CurrencyPopoverVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.transform(.init())

        setupFilterByDateButton()
        sutupNavBarItems()
        bindToSettingsBarButtonItem(output)
        bindToCurrencyBarButtonItem(output)
        bindToNotificationBarButtonItem(output)
        bindToTitleImageBarButtonItem(output)
        bindToFilterByDateButtonConfig(output)
        bindCalendarPopover(output)
        bindCurrencyPopover(output)
    }
    
    // MARK: Make binding
    
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

    
    // MARK: - Setup views
    
    private func setupFilterByDateButton() {
        view.addSubview(filterByDateButton)
        filterByDateButton.snp.makeConstraints { make in
            make.horizontalEdges
                .equalToSuperview()
                .inset(16)
            make.height
                .equalTo(44)
            make.top.equalToSuperview()
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


class CalendarPopoverVC: UIViewController {
    let calendar = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.preferredDatePickerStyle = .inline
        calendar.datePickerMode = .date
        view.addSubview(calendar)
        calendar.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
    }
    
}


class CurrencyPopoverVC: UIViewController {
    
}
