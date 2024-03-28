//
//  SalesVC.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SalesVC: BaseViewController {

    private let visibleSection = PublishSubject<Int>()
    private let selectedCalendarDates = PublishSubject<(Date,Date?)>()
    private let selectedCancelCalendar = PublishSubject<Void>()
    
    // MARK: - UI elements
    
    private lazy var setupView = SalesSetupView()
    private lazy var collectionView = ProductsCollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )
    
    private lazy var calendarPopover = RangedCalendarBuilder.buildRangedCalendarModule(delegate: self)
    private lazy var marketplacesPopover = MarketplacesPopoverVC()
    
    var viewModel: SalesViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sales"

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
                visibleSection: visibleSection.asDriverOnErrorJustComplete(),
                marketplaceSelected: marketplacesPopover.itemSelected(),
                selectedCalendarDates: selectedCalendarDates.asDriverOnErrorJustComplete(), 
                selectedCancelCalendar: selectedCancelCalendar.asDriverOnErrorJustComplete()
            )
        )
        
        
        setupSetupView()
        setupCollection()
        subscribeOnVisebleSection()
        
        bindToBanner(output)
        bindToAlert(output)
        bindToSetupView(output)
        bindToCollectionView(output)
        bindToLoader(output)
        bindToPaginatedCollectionLoader(output)
        bindToMarketplaces(output)
        bingCalendarPopover(output)
        bindMarketplacesPopover(output)
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        return layout
    }
    
    private func setupSetupView() {
        view.addSubview(setupView)
        setupView.snp.makeConstraints { make in
            make.top
                .horizontalEdges
                .equalToSuperview()
                .inset(10)
        }
    }
    
    private func setupCollection() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top
                .equalTo(setupView.snp.bottom)
                .offset(10)
            make.horizontalEdges
                .bottom
                .equalToSuperview()
        }
    }
    
}

// MARK: Subscribers

extension SalesVC {
    
    private func subscribeOnVisebleSection() {
        collectionView
            .subscribeOnVisibleSection()
            .drive(visibleSection)
            .disposed(by: disposeBag)
    }
    
}

// MARK: Make binding

extension SalesVC {

    private func bindToLoader(_ output: SalesViewModel.Output) {
        output.fetching
            .drive(collectionView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindToBanner(_ output: SalesViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
    private func bindToAlert(_ output: SalesViewModel.Output) {
        output.alert
            .drive(rx.alert)
            .disposed(by: disposeBag)
    }
    
    private func bindToSetupView(_ output: SalesViewModel.Output) {
        output.setupViewInput
            .drive(setupView.rx.input)
            .disposed(by: disposeBag)
    }
    
    private func bindToCollectionView(_ output: SalesViewModel.Output) {
        collectionView.bind(output.collectionData)
            .disposed(by: disposeBag)
    }
    
    private func bindToPaginatedCollectionLoader(_ output: SalesViewModel.Output) {
        collectionView.bindToPaginatedLoader(output.isShowPaginatedLoader)
            .disposed(by: disposeBag)
    }
    
    private func bindToMarketplaces(_ output: SalesViewModel.Output) {
        marketplacesPopover
            .bind(output.marketplacesData)
            .disposed(by: disposeBag)
    }
    
    private func bingCalendarPopover(_ output: SalesViewModel.Output) {
        output.showCalendarPopover
            .withUnretained(self)
            .map { owner, point in
                PopoverManager.Input(
                    bindingType: .point(point),
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
    
    private func bindMarketplacesPopover(_ output: SalesViewModel.Output) {
        output.showMarketplacesPopover
            .withUnretained(self)
            .map { owner, point in
                PopoverManager.Input(
                    bindingType: .point(point),
                    preferredSize: .init(
                        width: 200,
                        height: 250
                    ),
                    popoverVC: owner.marketplacesPopover
                )
            }
            .drive(rx.popover)
            .disposed(by: disposeBag)
    }
    
}

// Calendar delegate methods

extension SalesVC: RangedCalendarPopoverDelegate {
    
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
