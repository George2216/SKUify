//
//  DashboardVC.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

final class DashboardVC: BaseViewController {
    var viewModel: DashboardViewModel!
    
    private let selectedCalendarDates = PublishSubject<(Date,Date?)>()
    private let selectedCancelCalendar = PublishSubject<Void>()
    
    // MARK: UI elements
    
    // nav bar items
    private lazy var settingsBarButtonItem = DefaultBarButtonItem()
    private lazy var currencyBarButtonItem = DefaultBarButtonItem()
    private lazy var notificationBarButtonItem = DefaultBarButtonItem()
    private lazy var titleImageBarButtonItem = DefaultBarButtonItem()

    private lazy var filterByDateButton = PopoverButton()
    
    private lazy var collectionView = DashboardCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
  
    private lazy var timeSlotsPopover = TimeSlotPopoverVC()
    private lazy var calendarPopover = RangedCalendarBuilder.buildRangedCalendarModule(delegate: self)
    private lazy var currencyPopoverController = CurrencyPopoverVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshingTriger = collectionView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let viewDidAppear = rx.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        // Hide the refresh control when dismiss the screen, otherwise it will hang.
        let viewDidDisappear = rx.sentMessage(#selector(UIViewController.viewDidDisappear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let output = viewModel.transform(
            .init(
                reloadData: Driver.merge(refreshingTriger, viewDidAppear),
                screenDisappear: viewDidDisappear,
                selectedCalendarDates: selectedCalendarDates.asDriverOnErrorJustComplete(),
                selectedCancelCalendar: selectedCancelCalendar.asDriverOnErrorJustComplete()
            )
        )

        setupFilterByDateButton()
        sutupNavBarItems()
        setupCollectionView()
        
        bindToSettingsBarButtonItem(output)
        bindToCurrencyBarButtonItem(output)
        bindToNotificationBarButtonItem(output)
        bindToTitleImageBarButtonItem(output)
        bindToFilterByDateButtonConfig(output)
        bindTimeSlotsPopover(output)
        bindCurrencyPopover(output)
        bingCalendarPopover(output)
        bindToCollectionView(output)
        bindToTimeSlotsPopover(output)
        bindToLoader(output)
        bindToBanner(output)
        bindToTopScrolling(output)
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
    private func bindToLoader(_ output: DashboardViewModel.Output) {
        output.fetching
            .drive(collectionView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindToBanner(_ output: DashboardViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
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
    
    // Bind to filetr by date popover button
    private func bindToFilterByDateButtonConfig(_ output: DashboardViewModel.Output) {
        output.filterByDatePopoverButtonConfig
            .drive(filterByDateButton.rx.config)
            .disposed(by: disposeBag)
    }
    
    // Bind to time slots popover view
    private func bindToTimeSlotsPopover(_ output: DashboardViewModel.Output) {
        timeSlotsPopover.bindToCollection(output.timeSlots)
            .disposed(by: disposeBag)
    }
    
    // Bind popover view
    private func bindTimeSlotsPopover(_ output: DashboardViewModel.Output) {
        output.showTimeSlotsPopover
            .withUnretained(self)
            .map { owner, center in
                PopoverManager.Input(
                    bindingType: .point(center),
                    preferredSize: .init(
                        width: owner.view.frame.width - 50,
                        height: 450
                    ),
                    popoverVC: owner.timeSlotsPopover
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
                    bindingType: .point(center),
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
    
    private func bingCalendarPopover(_ output: DashboardViewModel.Output) {
        output.showCalendarPopover
            .withUnretained(self)
            .map { owner, _ in
                PopoverManager.Input(
                    bindingType: .view(owner.filterByDateButton),
                    preferredSize: .init(
                        width: owner.view.frame.width - 20,
                        height: owner.view.frame.width - 50
                    ),
                    popoverVC: owner.calendarPopover
                )
            }
            .drive(rx.popover)
            .disposed(by: disposeBag)
    }
    
    private func bindToTopScrolling(_ output: DashboardViewModel.Output) {
        output.fetching
            .withUnretained(self)
            .drive(onNext: { owner, isFetching in
                guard isFetching else { return }
                owner.collectionView
                    .setContentOffset(
                        CGPoint(
                            x: 0,
                            y: -owner.collectionView
                                .refreshControl!.frame
                                .height
                        ),
                        animated: true
                    )
            })
            .disposed(by: disposeBag)
    }
    
    
}

extension DashboardVC: RangedCalendarPopoverDelegate {
    func cancelCalendar() {
        selectedCancelCalendar.onNext(())
        calendarPopover.dismiss(animated: true)
    }
    
    func selectedCalendarDates(
        startDate: Date,
        endDate: Date?
    ) {
        selectedCalendarDates.onNext((startDate, endDate))
        calendarPopover.dismiss(animated: true)
    }
    
}
