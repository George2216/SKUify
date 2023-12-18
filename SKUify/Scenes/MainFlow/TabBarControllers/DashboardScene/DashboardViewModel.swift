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
        let salesValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.99, 0.0, 25.33, 4.34, 0.0, 0.0, 13.47, 0.0, 14.4, 0.0, 0.0, 10.99, 0.0, 8.32, 6.99]
        let compareValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.99, 26.97, 8.99, 17.98, 0.0, 0.0, 9.0, 18.98, 0.0, 8.99]

        let maxLength = max(salesValues.count, compareValues.count)

        var mockPoints: [CGPoint] = []

        for i in 0..<maxLength {
            let salesValue = i < salesValues.count ? salesValues[i] : 0.0
            let compareValue = i < compareValues.count ? compareValues[i] : 0.0

            let entry = CGPoint(x: Double(i), y: salesValue)
            mockPoints.append(entry)

            let entryCompare = CGPoint(x: Double(i), y: compareValue)
            mockPoints.append(entryCompare)
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



