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

    private let showCurrencyPopover = PublishSubject<CGPoint>()
    private let showTimeSlotsPopover = PublishSubject<CGPoint>()
    private let showCalendarPopover = PublishSubject<Void>()
    
    private let toSettings = PublishSubject<Void>()
        
    private let dashboardDataState = BehaviorSubject<DashboardDataState>(value: .today)
    
    private lazy var collectionData = BehaviorSubject<[DashboardSectionModel]>(value: [])
    
    // Is Show chart
    private let salesIsShow = BehaviorSubject<Bool>(value: true)
    private let unitSoldIsShow = BehaviorSubject<Bool>(value: true)
    private let profitIsShow = BehaviorSubject<Bool>(value: true)
    private let refundsIsShow = BehaviorSubject<Bool>(value: true)
    private let marginIsShow = BehaviorSubject<Bool>(value: true)
    private let roiIsShow = BehaviorSubject<Bool>(value: true)
    
    private var chartsVisible: Driver<(Bool, Bool, Bool, Bool, Bool, Bool)> {
        Driver.combineLatest(
            salesIsShow.asDriverOnErrorJustComplete(),
            unitSoldIsShow.asDriverOnErrorJustComplete(),
            profitIsShow.asDriverOnErrorJustComplete(),
            refundsIsShow.asDriverOnErrorJustComplete(),
            marginIsShow.asDriverOnErrorJustComplete(),
            roiIsShow.asDriverOnErrorJustComplete()
        )
    }
    
    // Dependencies
    private let navigator: DashboardNavigatorProtocol
    
    // Use case storage
    
    private let chartUseCase: Domain.ChartsUseCase
    private let marketplacesUseCase: Domain.MarketplacesReadUseCase
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: DashboardUseCases,
        navigator: DashboardNavigatorProtocol
    ) {
        self.navigator = navigator
        self.chartUseCase = useCases.makeChartsUseCase()
        self.marketplacesUseCase = useCases.makeMarketplacesUseCase()
        
        navigateToSettings()
        bindChartsDataToCollectionDataStorage()
        changeChartsVisible()
    }
    
    func transform(_ input: Input) -> Output {
        subscribeOnReloadData(input)
        subscribeOnSelectedCalendarDates(input)
        return Output(
            settingsBarButtonConfig: makeSettingsBarButtonConfig(),
            currencyBarButtonConfig: makeCurrencyBarButtonConfig(),
            notificationBarButtonConfig: makeNotificationBarButtonConfig(),
            titleImageBarButtonConfig: makeTitleImageBarButtonConfig(),
            filterByDatePopoverButtonConfig: makeFilterByDatePopoverButtonConfig(),
            collectionData: collectionData.asDriverOnErrorJustComplete(),
            showCurrencyPopover: showCurrencyPopover.asDriverOnErrorJustComplete(),
            showTimeSlotsPopover: showTimeSlotsPopover.asDriverOnErrorJustComplete(),
            showCalendarPopover: showCalendarPopover.asDriverOnErrorJustComplete(),
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
    
    private func subscribeOnSelectedCalendarDates(_ input: Input) {
        input.selectedCalendarDates
            .withUnretained(self)
            .drive(onNext: { (owner, arg1) in
                let (startDate, endDate) = arg1
                owner.dashboardDataState.onNext(
                    .custom(
                        startDate: startDate,
                        endDate: endDate
                    )
                )
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
                            switch cases[row] {
                            case .custom:
                                self.showCalendarPopover.onNext(())
                            default:
                                self.dashboardDataState.onNext(cases[row])

                            }
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
                actionType: .popUp({ [weak self] center in
                    guard let self else { return }
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
            .asDriverOnErrorJustComplete()
            .flatMapLatest(weak: self) { owner, state in
                //chartUseCase methods can return an error if it needs to go inside the FlapMap and return the driver so that the error does not reach the subscriber
                owner.makeChartsDataByState(state: state)
            }
    }
    
    private func makeChartsDataByState(state: DashboardDataState) -> Driver<ChartMainDTO> {
        let observable: Observable<ChartMainDTO>?
        switch state {
        case .today:
            observable =  chartUseCase
                .chartsToday(state.startDate)
        case .yesterday:
            observable = chartUseCase
                 .chartsYesterday(state.startDate)
        case .days7:
            observable = chartUseCase
                 .chartsWeek(state.startDate)
        case .days30:
            observable =  chartUseCase
                 .chartsMonth(state.startDate)
        case .days90:
            observable =  chartUseCase
                 .chartsQuarter(state.startDate)
        case .days365:
            observable =  chartUseCase
                 .chartsYear(state.startDate)
        case .all:
            observable = chartUseCase
                 .chartsAll()
        case .custom:
            observable = chartUseCase
                .chartsCustom(
                    state.startDate,
                    state.endDate
                )
        }
        return observable?
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete() ?? .empty()
    }
    
    // MARK: Charts visibility
    
    private func changeChartsVisible() {
        chartsVisible
            .withLatestFrom(collectionData.asDriverOnErrorJustComplete()) { visibles, collectionData in
                return (visibles, collectionData)
            }
            .withUnretained(self)
            .drive(onNext: { (owner, arg1) in
                let (salesIsShow, unitSoldIsShow, profitIsShow, refundsIsShow, marginIsShow, roiIsShow) = arg1.0
                let collectionData = arg1.1

                let updatetCollectionData = collectionData.map { section -> DashboardSectionModel in
                    
                    let items = section.items.map { item -> DashboardCollectionItem in
                        switch item {
                        case .financialMetric(let input):
                            let updatedInput = owner.updateFinancialMetricInputBuyIsShowState(
                                input: input,
                                salesIsShow: salesIsShow,
                                unitSoldIsShow: unitSoldIsShow,
                                profitIsShow: profitIsShow,
                                refundsIsShow: refundsIsShow,
                                marginIsShow: marginIsShow,
                                roiIsShow: roiIsShow
                            )
                            return .financialMetric(updatedInput)
                        case .overview(let input):
                            let updatedInput = owner.updateOveviewInputBuyIsShowState(
                                input: input,
                                salesIsShow: salesIsShow,
                                unitSoldIsShow: unitSoldIsShow,
                                profitIsShow: profitIsShow,
                                refundsIsShow: refundsIsShow,
                                marginIsShow: marginIsShow,
                                roiIsShow: roiIsShow
                            )
                            return .overview(updatedInput)
                        default:
                            return item
                        }
                    }
                    
                    return .init(
                        model: section.model,
                        items: items
                    )
                }
                
                owner.collectionData.onNext(updatetCollectionData)
            })
            .disposed(by: disposeBag)

    }
    
    private func updateFinancialMetricInputBuyIsShowState(
        input: FinancialMetricDashboardCell.Input,
        salesIsShow: Bool,
        unitSoldIsShow: Bool,
        profitIsShow: Bool,
        refundsIsShow: Bool,
        marginIsShow: Bool,
        roiIsShow: Bool
    ) -> FinancialMetricDashboardCell.Input {
        var input = input
        switch input.cellType {
        case .sales:
            input.switchState = salesIsShow
        case .unitsSold:
            input.switchState = unitSoldIsShow
        case .profit:
            input.switchState = profitIsShow
        case .refunds:
            input.switchState = refundsIsShow
        case .margin:
            input.switchState = marginIsShow
        case .roi:
            input.switchState = roiIsShow
        }
        return input
    }
    
    
    private func updateOveviewInputBuyIsShowState(
        input: OverviewDashboardCell.Input,
        salesIsShow: Bool,
        unitSoldIsShow: Bool,
        profitIsShow: Bool,
        refundsIsShow: Bool,
        marginIsShow: Bool,
        roiIsShow: Bool
    ) -> OverviewDashboardCell.Input {
        var input = input
        input.chartsData = input.chartsData.map { item in
            var item = item
            switch item.chartType {
            case .sales:
                item.isVisible = salesIsShow
            case .unitsSold:
                item.isVisible = unitSoldIsShow
            case .profit:
                item.isVisible = profitIsShow
            case .refunds:
                item.isVisible = refundsIsShow
            case .margin:
                item.isVisible = marginIsShow
            case .roi:
                item.isVisible = roiIsShow
            }
            return item
        }
        
        input.markerData = input.markerData.map { input in
            var input = input
            input.content = input.content.map { item in
                var item = item
                switch item.chartType {
                case .sales:
                    item.isVisible = salesIsShow
                case .unitsSold:
                    item.isVisible = unitSoldIsShow
                case .profit:
                    item.isVisible = profitIsShow
                case .refunds:
                    item.isVisible = refundsIsShow
                case .margin:
                    item.isVisible = marginIsShow
                case .roi:
                    item.isVisible = roiIsShow
                }
                return item
                
            }
            return input
        }
        return input
    }

    // MARK: -  Make collection data
   
    private func bindChartsDataToCollectionDataStorage() {
        makeChartsData()
            .drive(collectionData)
            .disposed(by: disposeBag)
    }
    
    private func makeChartsData() -> Driver<[DashboardSectionModel]> {
        fetchChartsByState()
            .withLatestFrom(dashboardDataState.asDriverOnErrorJustComplete()) { data, state in
                return (data, state)
            }
            .flatMapLatest(
                weak: self,
                selector: { (owner, arg1) in
                    let (data, state) = arg1
                    
                    return Driver.combineLatest(
                        Driver<ChartMainDTO>.just(data),
                        Driver<DashboardDataState>.just(state),
                        owner.getMarketplacesData(data.chart.marketplaces)
                    )
                }
            )
            .withUnretained(self)
            .map(
                { owner, combinedData in
                    let (mainData, state, marketplaces) = combinedData
                    
                    let data = mainData.chart
                    let chartsData = data.chartData
                    
                    let markerData = owner.makeOverviewMarkerData(chartsData: chartsData)
                    
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
                            items: owner.makeOverviewItems(
                                chartsData: chartsData,
                                markerData: markerData
                            )
                        ),
                        .init(
                            model: .marketplaceSection(
                                header: "",
                                footer: ""
                            ),
                            items: owner.makeMarketlaceItems(
                                marketplaces: marketplaces,
                                currency: data.currency
                            )
                        )
                    ]
                }
            )
        
    }
    
    // MARK: - Make collection view items
    
    // MARK: - Financial metric items
    
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
                        switchChangedOn: { [weak self] isOn in
                            guard let self else { return }
                            self.salesIsShow.onNext(isOn)
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
                        switchChangedOn: { [weak self] isOn in
                            guard let self else { return }
                            self.unitSoldIsShow.onNext(isOn)
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
                        switchChangedOn: { [weak self] isOn in
                            guard let self else { return }
                            self.profitIsShow.onNext(isOn)
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
                        switchChangedOn: { [weak self] isOn in
                            guard let self else { return }
                            self.refundsIsShow.onNext(isOn)
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
                        switchChangedOn: { [weak self] isOn in
                            guard let self else { return }
                            self.marginIsShow.onNext(isOn)
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
                        switchChangedOn: { [weak self] isOn in
                            guard let self else { return }
                            self.roiIsShow.onNext(isOn)
                        }
                    )
                )
            ]
    }
    
    // MARK: - Overview items

    private func makeOverviewItems(
        chartsData: ChartDataDTO,
        markerData: [OverviewChartMarkerView
            .Input]
    ) -> [DashboardCollectionItem] {
        [
            .overview(
                .init(
                    labels: makeOverviewLabels(labels: chartsData.labels),
                    chartsData: [
                        .init(
                            chartType: .sales,
                            points: makePoints(from: chartsData.sales.values),
                            isVisible: true
                        ),
                        .init(
                            chartType: .unitsSold,
                            points: makePoints(from: chartsData.unitsSold.values),
                            isVisible: true
                        ),
                        .init(
                            chartType: .profit,
                            points: makePoints(from: chartsData.profit.values),
                            isVisible: true
                        ),
                        .init(
                            chartType: .refunds,
                            points: makePoints(from: chartsData.refunds.values),
                            isVisible: true
                        ),
                        .init(
                            chartType: .margin,
                            points: makePoints(from: chartsData.margin.values),
                            isVisible: true
                        ),
                        .init(
                            chartType: .roi,
                            points: makePoints(from: chartsData.roi.values),
                            isVisible: true
                        )
                    ],
                    markerData: markerData
                )
            )
        ]
    }
    
    // MARK: - Make overview labels
    
    private func makeOverviewLabels(labels: [String]) -> [String] {
        var datesArray = labels.map { label in
            var label = label
            insertNewlineIfNeededOverviewLabels(to: &label)
            return label
        }
        
        let desiredCount = 6
        var step = 1
        var isContinue = true
        
        if desiredCount < labels.count {
            var newArray: [String] = []
            
            while isContinue {
                newArray = generateNewArrayOverviewLabels(from: datesArray, step: step)
                
                if step >= datesArray.count {
                    newArray = [labels.first!, labels.last!]
                    isContinue = false
                } else if newArray.last != labels.last || newArray.count > desiredCount {
                    step += 1
                    datesArray = labels
                    newArray = []
                } else {
                    isContinue = false
                }
            }
            return newArray
        }
        return labels
    }
    
    private func insertNewlineIfNeededOverviewLabels(to label: inout String) {
        let words = label.components(separatedBy: .whitespacesAndNewlines)
        if words.count >= 3 {
            label.insert(
                contentsOf: "\n",
                at: label.index(
                    label.startIndex,
                    offsetBy: words[0].count + words[1].count + 1
                )
            )
        }
    }
    
    private func generateNewArrayOverviewLabels(from labels: [String], step: Int) -> [String] {
        var newArray: [String] = []
        for (index, element) in labels.enumerated() {
            if index % (step + 1) == 0 {
                newArray.append(element)
            }
        }
        return newArray
    }
    
    
    
    private func makeOverviewMarkerData(chartsData: ChartDataDTO) -> [OverviewChartMarkerView
        .Input] {
            chartsData.labels
                .enumerated()
                .map { index, label in
                    OverviewChartMarkerView
                        .Input(
                            content: [
                                .init(
                                    chartType: .sales,
                                    isVisible: true,
                                    contentData: .init(
                                        date: label,
                                        value: "\(chartsData.sales.values[index])"
                                    )
                                ),
                                .init(
                                    chartType: .unitsSold,
                                    isVisible: true,
                                    contentData: .init(
                                        date: label,
                                        value: "\(chartsData.profit.values[index])"
                                    )
                                ),
                                .init(
                                    chartType: .profit,
                                    isVisible: true,
                                    contentData: .init(
                                        date: label,
                                        value: "\(chartsData.sales.values[index])"
                                    )
                                ),
                                .init(
                                    chartType: .refunds,
                                    isVisible: true,
                                    contentData: .init(
                                        date: label,
                                        value: "\(chartsData.refunds.values[index])"
                                    )
                                ),
                                .init(
                                    chartType: .margin,
                                    isVisible: true,
                                    contentData: .init(
                                        date: label,
                                        value: "\(chartsData.margin.values[index])"
                                    )
                                ),
                                .init(
                                    chartType: .roi,
                                    isVisible: true,
                                    contentData: .init(
                                        date: label,
                                        value: "\(chartsData.roi.values[index])"
                                    )
                                )
                            ]
                        )
                }
        }
    
    // MARK: - Marketplace items

    private func makeMarketlaceItems(
        marketplaces: [(String, String, ChartMarketplace)],
        currency: String
    ) -> [DashboardCollectionItem] {
        marketplaces.enumerated()
            .map { (index, arg1) in
                let (title, countryCode, marketplace) = arg1
                let isTopCell = index == 0
                return .marketplace(
                    .init(
                        title: isTopCell ? "Marketplace" : "",
                        isTopCell: isTopCell,
                        isBottomCell: index == marketplaces.count - 1,
                        topViewInput: .init(
                            title: "Market",
                            marketplace: title.capitalized,
                            countryCode: countryCode
                        ),
                        contentInput: .init(
                            sales: .init(
                                title: "Sales",
                                value: "\(currency)\(marketplace.sales)"
                            ),
                            profit: .init(
                                title: "Profit",
                                value: "\(currency)\(marketplace.profit)"
                            ),
                            refunds: .init(
                                title: "Refunds",
                                value: "\(currency)\(marketplace.refunds)"
                            ),
                            unit: .init(
                                title: "Unit",
                                value: "\(marketplace.unitsSold)"
                            ),
                            roi: .init(
                                title: "Roi",
                                value: "\(marketplace.roi)%"
                            ),
                            margin: .init(
                                title: "Margin",
                                value: "\(marketplace.margin)%"
                            )
                        )
                    )
                )
        }
    }
    
    private func getMarketplacesData(_ marketplaces: [ChartMarketplace]) -> Driver<[(String, String, ChartMarketplace)]> {
        let observables = marketplaces.map { marketplace in
            marketplacesUseCase.getMarketplaceById(id: marketplace.marketplace)
                .map({ ($0.country, $0.countryCode, marketplace) })
                .catchAndReturn(("Total", "", marketplace))
                .asDriverOnErrorJustComplete()
        }
        
        return Driver.zip(observables)
    }
    
    // MARK: - Collection data helpers

    
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
    
}

extension DashboardViewModel {
    struct Input {
        let reloadData: Driver<Void>
        let selectedCalendarDates: Driver<(Date,Date?)>
    }
    
    struct Output {
        // Navigation buttons configs
        let settingsBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let currencyBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let notificationBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let titleImageBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        // Buttons config
        let filterByDatePopoverButtonConfig: Driver<PopoverButton.Config>
        // Collection data
        let collectionData: Driver<[DashboardSectionModel]>
        // Popovers points
        let showCurrencyPopover: Driver<CGPoint>
        let showTimeSlotsPopover: Driver<CGPoint>
        let showCalendarPopover: Driver<Void>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
        // TimeSlots
        let timeSlots: Driver<[TimeSlotCell.Input]>
    }
    
}
