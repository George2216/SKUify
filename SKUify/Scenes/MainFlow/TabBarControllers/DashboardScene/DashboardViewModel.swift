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
import RxExtensions

final class DashboardViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()

    // Dependencies
    private let navigator: DashboardNavigatorProtocol
    
    // Use case storage
    
    private let chartUseCase: Domain.ChartsUseCase
    
    private let showCurrencyPopover = PublishSubject<CGPoint>()
    private let showTimeSlotsPopover = PublishSubject<CGPoint>()

    private let toSettings = PublishSubject<Void>()
        
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
        self.chartUseCase = useCases.makeChartsUseCase()
        
        navigateToSettings()
    }
    
    func transform(_ input: Input) -> Output {
        subscribeOnReloadData(input)
        return Output(
            settingsBarButtonConfig: makeSettingsBarButtonConfig(),
            currencyBarButtonConfig: makeCurrencyBarButtonConfig(),
            notificationBarButtonConfig: makeNotificationBarButtonConfig(),
            titleImageBarButtonConfig: makeTitleImageBarButtonConfig(),
            filterByDatePopoverButtonConfig: makeFilterByDatePopoverButtonConfig(),
            collectionData: makeChartsData(),
            showCurrencyPopover: showCurrencyPopover.asDriverOnErrorJustComplete(),
            showTimeSlotsPopover: showTimeSlotsPopover.asDriverOnErrorJustComplete(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error),
            timeSlots: makeTimeSlotsInput()
        )
    }
    
    // MARK: - Subscribers from input
    
    private func subscribeOnReloadData(_ input: Input) {
        input.reloadData
            .withLatestFrom(dashboardDataState.asDriverOnErrorJustComplete())
            .withUnretained(self)
            .drive(onNext: { owner, state in
                owner.dashboardDataState.onNext(state)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Make time slots data
    
    private func makeTimeSlotsInput() -> Driver<[TimeSlotCell.Input]> {
        let cases = DashboardDataState.allCases
        return Driver<[TimeSlotCell.Input]>.just(
            cases
                .map { item in
                    TimeSlotCell.Input(
                        title: item.title,
                        selectRow: { [weak self] row in
                            guard let self else { return }
                            self.dashboardDataState.onNext(cases[row])
                        }
                    )
                }
        )
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
                    self.showTimeSlotsPopover.onNext(center)
                }
            )
        )
    }
    

    private func fetchChartsByState() -> Driver<ChartMainDTO> {
        dashboardDataState
            .flatMap(weak: self) { owner, state in
                let chartUseCase = owner.chartUseCase
                var chartsObservable: Observable<ChartMainDTO>?
                
                switch state {
                case .today:
                    chartsObservable = chartUseCase
                        .chartsToday(state.startDate)
                case .yesterday:
                    chartsObservable = chartUseCase
                         .chartsYesterday(state.startDate)
                case .days7:
                    chartsObservable = chartUseCase
                         .chartsWeek(state.startDate)
                case .days30:
                    chartsObservable = chartUseCase
                         .chartsMonth(state.startDate)
                case .days90:
                    chartsObservable = chartUseCase
                         .chartsQuarter(state.startDate)
                case .days365:
                    chartsObservable = chartUseCase
                         .chartsYear(state.startDate)
                case .all:
                    chartsObservable = chartUseCase
                         .chartsAll()
                case .custom:
                    chartsObservable = chartUseCase
                         .chartsCustom(state.startDate, "")
                }
                return chartsObservable?
                    .trackActivity(owner.activityIndicator)
                    .trackError(owner.errorTracker) ?? .empty()
            }
            .asDriverOnErrorJustComplete()
        
    }
    
  
    func makePoints(from array: [Double]) -> [CGPoint] {
        guard array.count > 2 else {
            return [
                CGPoint(
                    x: 0,
                    y: 0
                ),
                CGPoint(
                    x: 1,
                    y: 0
                )
            ]
        }
        return array.enumerated()
            .map { index, item in
                CGPoint(
                    x: Double(index),
                    y: array[index]
                )
            }
    }
    
    
    private func calculatePercentageAndStatus(
        value: Double,
        compared: Double?
    ) -> (Double, FMDetailView.PercentStatus) {
      let percentage = calculatePercentageChange(
        value: value,
        compared: compared
      )
        if percentage.isZero {
            return (percentage, .unchanged)
        } else if percentage.isPositive {
            return (percentage, .positive)
        } else if percentage.isNegative {
            return (abs(percentage), .negative)
        }
        
        return (0.0, .unchanged)
    }
    private func calculatePercentageChange(
        value: Double,
        compared: Double?
    ) -> Double {
        if let compared, compared != 0 {
            let percentageChange = ((value - compared) / abs(compared)) * 100
            return (round(percentageChange * 100) / 100)
        } else if (compared == 0.0 || compared == nil) && value == 0 {
            return 0.0
        } else if compared == 0 && value != 0.0 {
            return 100.0
        }
        return 0.0
    }

    
    
    // MARK: -  Make collection data

    private func makeChartsData() -> Driver<[DashboardSectionModel]> {
        fetchChartsByState()
            .withLatestFrom(dashboardDataState.asDriverOnErrorJustComplete()) { data, state in
                   return (data, state)
               }
            .withUnretained(self)
            .map { owner, combinedData -> [DashboardSectionModel] in
                let state = combinedData.1
                
                let data = combinedData.0.chart
                let chartsData = data.chartData
                let items: [DashboardCollectionItem] = [
                    .overview(.init(
                        labels: chartsData.labels,
                        chartsData: [
                            .init(
                                chartType: .sales,
                                points: owner.makePoints(from: chartsData.sales.values)
                            ),
                            .init(
                                chartType: .unitsSold,
                                points: owner.makePoints(from: chartsData.unitsSold.values)
                            ),
                            .init(
                                chartType: .profit,
                                points: owner.makePoints(from: chartsData.profit.values)
                            ),
                            .init(
                                chartType: .refunds,
                                points: owner.makePoints(from: chartsData.refunds.values)
                            ),
                            .init(
                                chartType: .margin,
                                points: owner.makePoints(from: chartsData.margin.values)
                            ),
                            .init(
                                chartType: .roi,
                                points: owner.makePoints(from: chartsData.roi.values)
                            )
                        ]
                    )
                    )
                ]
                return [
                    .init(
                        model: .defaultSection(
                            header: "",
                            footer: ""
                        ),
                        items: owner.makeFinancialMetricItems(
                            data: data,
                            state: state
                        )
                    ),
                    .init(
                        model: .defaultSection(
                            header: "",
                            footer: ""
                        ),
                        items: items
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

    }
    
    //MARK: - Make items
    
    private func makeFinancialMetricItems(
        data: ChartDTO,
        state: DashboardDataState
    ) -> [DashboardCollectionItem] {
        let chartData = data.chartData
        let currency = data.currency
        
        let (salesPercentage, salesPercentageStatus)  = calculatePercentageAndStatus(
            value: data.sales,
            compared: data.salesCompared
        )
        
        let (unitsSoldPercentage, unitsSoldPercentageStatus)  = calculatePercentageAndStatus(
            value: data.unitsSold,
            compared: data.unitsSoldCompared
        )
        
        let (profitPercentage, profitPercentageStatus)  = calculatePercentageAndStatus(
            value: data.profit,
            compared: data.profitCompared
        )
        
        let (refundsPercentage, refundsPercentageStatus)  = calculatePercentageAndStatus(
            value: data.refunds,
            compared: data.refundsCompared
        )
        
        let (marginPercentage, marginPercentageStatus)  = calculatePercentageAndStatus(
            value: data.margin,
            compared: data.marginCompared
        )
        
        let (roiPercentage, roiPercentageStatus)  = calculatePercentageAndStatus(
            value: data.roi,
            compared: data.roiCompared
        )
        
        return [
            .financialMetric(
                    .init(
                        cellType: .sales,
                        detailInput: .init(
                            percentStatus: salesPercentageStatus,
                            percentage: "\(salesPercentage)%",
                            rangeTitle: state.title,
                            rangeVaue: "\(currency)\(data.salesCompared ?? 0.0)"
                        ),
                        switchState: true,
                        sum: "\(currency)\(data.sales)",
                        points: makePoints(from: chartData.sales.values),
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
                        detailInput: .init(
                            percentStatus: unitsSoldPercentageStatus,
                            percentage: "\(unitsSoldPercentage)%",
                            rangeTitle: state.title,
                            rangeVaue: "\(data.unitsSoldCompared ?? 0.00)"
                        ),
                        switchState: true,
                        sum: "\(data.unitsSold)",
                        points: makePoints(from: chartData.unitsSold.values),
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
                        detailInput: .init(
                            percentStatus: profitPercentageStatus,
                            percentage: "\(profitPercentage)%",
                            rangeTitle: state.title,
                            rangeVaue: "\(currency)\(data.profitCompared ?? 0.00)"
                        ),
                        switchState: true,
                        sum: "\(currency)\(data.profit)",
                        points: makePoints(from: chartData.profit.values),
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
                        detailInput: .init(
                            percentStatus: refundsPercentageStatus,
                            percentage: "\(refundsPercentage)%",
                            rangeTitle: state.title,
                            rangeVaue: "\(currency)\(data.refundsCompared ?? 0.00)"
                        ),
                        switchState: true,
                        sum: "\(currency)\(data.refunds)",
                        points: makePoints(from: chartData.refunds.values),
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
                        detailInput: .init(
                            percentStatus: marginPercentageStatus,
                            percentage: "\(marginPercentage)%",
                            rangeTitle: state.title,
                            rangeVaue: "\(data.marginCompared ?? 0.00)%"
                        ),
                        switchState: true,
                        sum: "\(data.margin)%",
                        points: makePoints(from: chartData.margin.values),
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
                        detailInput: .init(
                            percentStatus: roiPercentageStatus,
                            percentage: "\(roiPercentage)%",
                            rangeTitle: state.title,
                            rangeVaue: "\(data.roiCompared ?? 0.00)%"
                        ),
                        switchState: true,
                        sum: "\(data.roi)%",
                        points: makePoints(from: chartData.roi.values),
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
            ]
    }
    
    
    // MARK: - Navigation
    
    private func navigateToSettings() {
        toSettings
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .drive(onNext: { owner, _ in
                owner.navigator.toSettings()
            })
            .disposed(by: disposeBag)
    }
    
    struct Input {
        let reloadData: Driver<Void>
    }
    
    struct Output {
        let settingsBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let currencyBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let notificationBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let titleImageBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        
        let filterByDatePopoverButtonConfig: Driver<PopoverButton.Config>
        
        let collectionData: Driver<[DashboardSectionModel]>
        // Popovers points
        let showCurrencyPopover: Driver<CGPoint>
        let showTimeSlotsPopover: Driver<CGPoint>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
        // TimeSlots
        let timeSlots: Driver<[TimeSlotCell.Input]>
    }
    
}

