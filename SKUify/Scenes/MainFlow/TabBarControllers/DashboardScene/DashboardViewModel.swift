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
    
    private let disposeBag = DisposeBag()

    // Dependencies
    private let navigator: DashboardNavigatorProtocol
    
    // Use case storage
    
    
    private let showCurrencyPopover = PublishSubject<CGPoint>()
    private let showCalendarPopover = PublishSubject<CGPoint>()

    private let toSettings = PublishSubject<Void>()
    
    private lazy var collectionData = BehaviorSubject<[DashboardSectionModel]>(value: makeCollectionData())
    
    private let dashboardDataState = BehaviorSubject<DashboardDataState>(value: .today)
    private let tapOnMarketplace = PublishSubject<String>()
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: DashboardUseCases,
        navigator: DashboardNavigatorProtocol
    ) {
        self.navigator = navigator
        
        toSettings
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigator.toSettings()
            }).disposed(by: disposeBag)
        
//        tapOnMarketplace
//            .withLatestFrom(
//                Observable
//                    .combineLatest(
//                        tapOnMarketplace,
//                        collectionData
//                    )
//            )
//            .withUnretained(self)
//            .subscribe(onNext: { (owner, arg1) in
//                var (marketplace, data) = arg1
//
//                data
//                    .enumerated()
//                    .forEach { (indexData, section) in
//                    section.items
//                        .enumerated()
//                        .forEach { (index, item)in
//                        switch item {
//                        case .marketplace(var input):
//                            var marketplaces = input.tableData
//                            if let index = marketplaces
//                                .map({ $0.title })
//                                .firstIndex(of: marketplace) {
//                                marketplaces[index].isSelected = !marketplaces[index].isSelected
//                            }
//                            input.marketplaces = marketplaces
//                            data[indexData].items[index] = .marketplace(input)
//                        default:
//                            break
//                        }
//                    }
//                }
//
//                owner.collectionData.onNext(data)
//
//            })
//            .disposed(by: disposeBag)
        
    }
    
    // MARK: -  Make bar button item configs
    
    private func makeSettingsBarButtonConfig() -> Driver<DefaultBarButtonItem.Config> {
        .just(
            .init(
                style: .image(.settings),
                actionType: .base({ [weak self] in
                    guard let self else { return }
                    self.toSettings.onNext(())
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
    
    // MARK: -  Make collection data

    private func makeCollectionData() -> [DashboardSectionModel] {
        let salesValues = [0.0,0.0,0.0,0.0,11.38,16.38,13.98,21.37,0.0,20.97,20.97,13.17,0.0,0.0,0.0,8.78,18.95,54.27,26.37,47.98,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]
        let compareValues = [79.94,32.93,44.31,35.97,32.01,23.98,31.97,40.83,76.89,63.74,46.27,35.97,38.21,68.93,21.14,44.95,21.98,63.06,40.96,40.36,61.95,19.98,0.0,77.32,27.93,19.98,35.97,55.89,30.37,0.0,51.73,60.0,36.96,27.93,37.92,28.97,50.52,11.99,115.41,35.97,49.95,43.67,44.75,23.98,16.38,35.97,16.38,0.0,49.37,0.0,44.75,20.94,4.39,4.39,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0]

        let maxLength = max(salesValues.count, compareValues.count)

        var mockPoints: [CGPoint] = []
        
//        for i in 0..<min(salesValues.count, compareValues.count) {
//            let entry = CGPoint(x: salesValues[i], y: Double(i))
//            mockPoints.append(entry)
//        }
        
        for i in 0..<salesValues.count {
            mockPoints.append(CGPoint(x: Double(i), y: salesValues[i]))

        }

        
        return  [
            .init(
                model: .defaultSection(header: "", footer: ""),
                items: [
                    .financialMetric(
                            .init(
                                cellType: .sales,
                                switchState: true,
                                sum: "$154,592.00",
                                precentage: "%37.8",
                                isUp: true,
                                points: mockPoints,
                                last90DaysPrice: "$423.30",
                                infoConfig: .init(
                                    title: "Sales",
                                    style: .infoButton,
                                    action: {

                                    }
                                ),
                                switchChangedOn: { _ in

                                }
                            )
                        ),
                        .financialMetric(
                            .init(
                                cellType: .unitsSold,
                                switchState: true,
                                sum: "$154,592.00",
                                precentage: "%37.8",
                                isUp: true,
                                points: mockPoints,
                                last90DaysPrice: "$223.30",
                                infoConfig: .init(
                                    title: "Units Sold",
                                    style: .infoButton,
                                    action: {

                                    }
                                ),
                                switchChangedOn: { _ in

                                }
                            )
                        ),
                        .financialMetric(
                            .init(
                                cellType: .profit,
                                switchState: true,
                                sum: "$154,592.00",
                                precentage: "%-37.8",
                                isUp: false,
                                points: mockPoints,
                                last90DaysPrice: "$223.30",
                                infoConfig: .init(
                                    title: "Profit",
                                    style: .infoButton,
                                    action: {

                                    }
                                ),
                                switchChangedOn: { _ in

                                }
                            )
                        ),
                        .financialMetric(
                            .init(
                                cellType: .refunds,
                                switchState: true,
                                sum: "$154,592.00",
                                precentage: "%37.8",
                                isUp: true,
                                points: mockPoints,
                                last90DaysPrice: "$223.30",
                                infoConfig: .init(
                                    title: "Refunds",
                                    style: .infoButton,
                                    action: {

                                    }
                                ),
                                switchChangedOn: { _ in

                                }
                            )
                        ),
                        .financialMetric(
                            .init(
                                cellType: .margin,
                                switchState: true,
                                sum: "$154,592.00",
                                precentage: "%37.8",
                                isUp: true,
                                points: mockPoints,
                                last90DaysPrice: "$223.30",
                                infoConfig: .init(
                                    title: "Margin",
                                    style: .infoButton,
                                    action: {

                                    }
                                ),
                                switchChangedOn: { _ in

                                }
                            )
                        ),
                        .financialMetric(
                            .init(
                                cellType: .roi,
                                switchState: true,
                                sum: "$154,592.00",
                                precentage: "%37.8",
                                isUp: true,
                                points: mockPoints,
                                last90DaysPrice: "$223.30",
                                infoConfig: .init(
                                    title: "ROI",
                                    style: .infoButton,
                                    action: {

                                    }
                                ),
                                switchChangedOn: { _ in

                                }
                            )
                        )
                        ,
                        .overview
                    ]
                ),
                .init(
                    model: .marketplaceSection(
                        header: "",
                        footer: ""
                    ),
                    items: [
                        .marketplace(
                            .init(
                                title: "Marketplace",
                                isTopCell: true,
                                topViewInput: .init(
                                    title: "Market",
                                    marketplace: "US"
                                ), contentInput: .init(
                                    sales: .init(
                                        title: "Sales",
                                        value: "$12,545.97"
                                    ),
                                    profit: .init(
                                        title: "Profit",
                                        value: "$2,545.78"
                                    ),
                                    refunds: .init(
                                        title: "Refunds",
                                        value: "12,546"
                                    ),
                                    unit: .init(
                                        title: "Unit",
                                        value: "12,546"
                                    ),
                                    roi: .init(
                                        title: "ROI",
                                        value: "15.51%"
                                    ),
                                    margin: .init(
                                        title: "Margin",
                                        value: "0.25%"
                                    )
                                )
                            )
                        ),
                        .marketplace(
                            .init(
                                isBottomCell: true,
                                topViewInput: .init(
                                    title: "Market",
                                    marketplace: "DE"
                                ), contentInput: .init(
                                    sales: .init(
                                        title: "Sales",
                                        value: "$12,545.97"
                                    ),
                                    profit: .init(
                                        title: "Profit",
                                        value: "$2,545.78"
                                    ),
                                    refunds: .init(
                                        title: "Refunds",
                                        value: "12,546"
                                    ),
                                    unit: .init(
                                        title: "Unit",
                                        value: "12,546"
                                    ),
                                    roi: .init(
                                        title: "ROI",
                                        value: "15.51%"
                                    ),
                                    margin: .init(
                                        title: "Margin",
                                        value: "0.25%"
                                    )
                                )
                            )
                        )
                    ]
                )
           ]
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            settingsBarButtonConfig: makeSettingsBarButtonConfig(),
            currencyBarButtonConfig: makeCurrencyBarButtonConfig(),
            notificationBarButtonConfig: makeNotificationBarButtonConfig(),
            titleImageBarButtonConfig: makeTitleImageBarButtonConfig(),
            filterByDatePopoverButtonConfig: makeFilterByDatePopoverButtonConfig(),
            collectionData: collectionData.asDriverOnErrorJustComplete(),
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
        
        let collectionData: Driver<[DashboardSectionModel]>
        let showCurrencyPopover: Driver<CGPoint>
        let showCalendarPopover: Driver<CGPoint>
    }
    
}

