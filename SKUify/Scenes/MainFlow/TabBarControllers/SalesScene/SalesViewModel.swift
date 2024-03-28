//
//  SalesViewModel.swift
//  SKUify
//
//  Created by George Churikov on 22.02.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class SalesViewModel: ViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    private let paginatedData = BehaviorSubject<SalesPaginatedModel>(value: .base())
    
    private let collectionDataStorage = BehaviorSubject<[ProductsSectionModel]>(value: [])
        
    private let isShowPaginatedLoader = PublishSubject<Bool>()
    
    private let tableType = BehaviorSubject<SalesTableType>(value: .orders)
    private let periodType = BehaviorSubject<SalesPeriodType>(value: .all)
    private let marketplaceType = BehaviorSubject<SalesMarketplaceType>(value: .all)
    
    private let paginationCounter = BehaviorSubject<Int?>(value: nil)
    private let productsCount = BehaviorSubject<Int>(value: 0)
    
    private let ordersDataStorage = BehaviorSubject<[SalesOrdersDTO]>(value: [])
    private let refundsDataStorage = BehaviorSubject<[SalesRefundsDTO]>(value: [])
    
    // MARK: - Start loading events for a specific table type
    
    private let loadingStarted = PublishSubject<Void>()

    private let showAlert = PublishSubject<AlertManager.AlertType>()

    // MARK: - Setup view actions
    
    private let searchTextChanged = PublishSubject<String>()
    private let tapOnCalendar = PublishSubject<CGPoint>()
    private let tapOnMarketplaces = PublishSubject<CGPoint>()
    private let changeCOGs = PublishSubject<Bool>()
    
    private let startSelectedMarketplace = PublishSubject<Int>()
    
    // Dependencies
    private let navigator: SalesNavigatorProtocol
    
    // Use case storage
    private let salesRefundsUseCase: Domain.SalesUseCase
    private let marketplacesUseCase: Domain.MarketplacesReadUseCase
    private let noteUseCase: Domain.NoteUseCase
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: SalesUseCases,
        navigator: SalesNavigatorProtocol
    ) {
        self.navigator = navigator
        self.salesRefundsUseCase = useCases.makeSalesUseCase()
        self.marketplacesUseCase = useCases.makeMarketplacesUseCase()
        self.noteUseCase = useCases.makeNoteSalesUseCase()
        
        paginatedDataScribers()
        collectionViewSubscribers()
        makeCollectionData()
    }
    
    func transform(_ input: Input) -> Output {
        subscribeOnVisibleSection(input)
        subscribeOnReloadData(input)
        subscribeOnScreenDisappear(input)
        subscribeOnMarketplaceSelected(input)
        subscribeOnSelectedCalendarDates(input)
        subscribeOnCancelCalendar(input)
        return Output(
            setupViewInput: makeSetupViewInput(),
            collectionData: collectionDataStorage.asDriverOnErrorJustComplete(),
            showCalendarPopover: tapOnCalendar.asDriverOnErrorJustComplete(),
            showMarketplacesPopover: tapOnMarketplaces.asDriverOnErrorJustComplete(),
            marketplacesData: makeMarketplacesData(),
            startSelectedMarketplace: startSelectedMarketplace.asDriverOnErrorJustComplete(),
            isShowPaginatedLoader: isShowPaginatedLoader.asDriverOnErrorJustComplete(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error),
            alert: showAlert.asDriverOnErrorJustComplete()
        )
    }
    
    private func reloadData() {
        // Clear storages
        ordersDataStorage.onNext([])
        refundsDataStorage.onNext([])
        // Remove products count
        productsCount.onNext(0)
        // Reload data
        paginationCounter.onNext(0)
    }
    
    // MARK: - Subscriptions to filters with SetupView
    
    private func paginatedDataScribers() {
        subscribeOnTableTypeChanged()
        subscribeOnSearchTextChanged()
        subscribeOnChangeCOGs()
        subscribeOnMarketplaceChange()
        subscribeonPeriodChange()
    }
    
    private func subscribeOnSearchTextChanged() {
        searchTextChanged
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { searchText, paginatedData in
                return (searchText, paginatedData)
            }
            .withUnretained(self)
        // Save to paginated data
            .do(onNext: { (owner, arg1) in
                var (searchText, paginatedData) = arg1
                paginatedData.searchText = searchText
                owner.paginatedData.onNext(paginatedData)
            })
        // Clear storages
            .do(onNext: { owner, _ in
                owner.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnChangeCOGs() {
        changeCOGs
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { isNoCOGs, paginatedData in
                return (isNoCOGs, paginatedData)
            }
            .withUnretained(self)
            .do(onNext: { (owner, arg1) in
                var (isNoCOGs, paginatedData) = arg1
                paginatedData.noCOGs = isNoCOGs
                owner.paginatedData.onNext(paginatedData)
            })
        // Clear storages
            .do(onNext: { owner, _ in
                owner.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Skip the first events so as not to start loading ahead of time

    
    private func subscribeOnTableTypeChanged() {
        tableType
            .skip(1)
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { tableType, paginatedData in
                return (tableType, paginatedData)
            }
            .withUnretained(self)
        // Save to paginated data
            .do(onNext: { (owner, arg1) in
                var (tableType, paginatedData) = arg1
                paginatedData.tableType = tableType
                owner.paginatedData.onNext(paginatedData)
            })
        // Clear storages
            .do(onNext: { (owner, _) in
                owner.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnMarketplaceChange() {
        marketplaceType
            .skip(1)
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { marketplaceType, paginatedData in
                return (marketplaceType, paginatedData)
            }
            .withUnretained(self)
            .do(onNext: { (owner, arg1) in
                var (marketplaceType, paginatedData) = arg1
                paginatedData.marketplaceType = marketplaceType
                owner.paginatedData.onNext(paginatedData)
            })
        // Clear storages
            .do(onNext: { owner, _ in
                owner.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeonPeriodChange() {
        periodType
            .skip(1)
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { period, paginatedData in
                return (period, paginatedData)
            }
            .withUnretained(self)
            .do(onNext: { (owner, arg1) in
                var (period, paginatedData) = arg1
                paginatedData.period = period
                owner.paginatedData.onNext(paginatedData)
            })
        // Clear storages
            .do(onNext: { owner, _ in
                owner.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Make setup view input
    
    private func makeSetupViewInput() -> Driver<SalesSetupView.Input> {
        return .just(
            .init(
                orderButtonConfig: makeOrdersButtonConfig(),
                refundsButtonConfig: makeRefundsButtonConfig(),
                filterByDatePopoverButtonConfig: .init(
                    title: "Filter by date",
                    action: { [weak self] point in
                        guard let self else { return }
                        self.tapOnCalendar.onNext(point)
                    })
                ,
                filterByMarketplacePopoverButtonConfig: .init(
                    title: "Filter by marketplace",
                    action: { [weak self] point in
                        guard let self else { return }
                        self.tapOnMarketplaces.onNext(point)
                    }),
                searchTextFieldConfig: .init(
                    style: .search,
                    plaseholder: "Search product",
                    debounce: 400,
                    textObserver: { [weak self] text in
                        guard let self else { return }
                        self.searchTextChanged.onNext(text)
                    }
                ),
                COGsInput: .init(
                    title : "No COGs",
                    switchState: false,
                    switchChanged: { [weak self] isCOGs in
                        guard let self else { return }
                        self.changeCOGs.onNext(isCOGs)
                    }
                )
            )
        )
    }
    
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
                    title: "Refunds",
                    style: type == .refunds ? .primary : .simplePrimaryText,
                    action: { [weak self] in
                        guard let self else { return }
                        self.tableType.onNext(.refunds)
                    }
                )
            }
    }
    
}

// MARK: Subscribers from Input

extension SalesViewModel {
    
    // Set paginated counter
    private func subscribeOnVisibleSection(_ input: Input) {
        let visibleSectionDriver = input.visibleSection
            .withLatestFrom(activityIndicator.asDriver()) { visibleSection, isItLoading in
                return (visibleSection, isItLoading)
            }
            .filter { _, isItLoading in
                return !isItLoading
            }
            .map { visibleSection, _ in visibleSection }
        
        let filterNotLastIndecesDriver = visibleSectionDriver
            .withLatestFrom(collectionDataStorage.asDriverOnErrorJustComplete()) { visibleSection, collectionDataStorage in
                return (visibleSection, collectionDataStorage.count)
            }
        // I filter out the cell index if it does not match the last one
            .filter { visibleSection, collectionDataStorageCount in
                return collectionDataStorageCount - 1 == visibleSection
            }
        
        let filterWhenLastProductDriver = filterNotLastIndecesDriver
            .withLatestFrom(paginationCounter.asDriverOnErrorJustComplete()) { (arg0, paginationCounter) in
                let (_, productsCount) = arg0
                return (paginationCounter, productsCount)
            }
        // If the paginationCountert is greater than the number of valid products, then you no longer need to download products
            .filter { paginationCounter, productsCount in
                return (paginationCounter ?? 0) < productsCount
            }
        
        let newPaginatedCounterDriver = filterWhenLastProductDriver
            .map { paginationCounter, _ in
                guard let paginationCounter else { return 15 }
                return paginationCounter + 15
            }
        
        // Show paginated loader
        newPaginatedCounterDriver
            .map { _ in true }
            .drive(isShowPaginatedLoader)
            .disposed(by: disposeBag)
        
        // Start load data
        newPaginatedCounterDriver
            .drive(paginationCounter)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnReloadData(_ input: Input) {
        input.reloadData
            .withUnretained(self)
            .drive(onNext: { owner, _ in
                owner.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnScreenDisappear(_ input: Input) {
        input.screenDisappear
            .drive(with: self) { owner, _ in
                owner.activityIndicator.stopTracker()
            }
            .disposed(by: disposeBag)
    }
    
    // Popover subscribers
    
    private func subscribeOnMarketplaceSelected(_ input: Input) {
        input.marketplaceSelected
            .flatMapLatest(weak: self) { owner, countryCode in
                owner.marketplacesUseCase
                    .getMarketplaceByCountryCode(countryCode)
                    .map { marketplace in
                        SalesMarketplaceType.marketplace(marketplace.countryCode)
                    }
                // All marketplaces if we don’t find them in storage
                    .asDriver(onErrorJustReturn: .all)
            }
            .drive(marketplaceType)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnSelectedCalendarDates(_ input: Input) {
        input.selectedCalendarDates
            .withUnretained(self)
            .do(onNext: { (owner, arg1) in
                let (startDate, endDate) = arg1
                guard startDate != Date() && endDate != nil else {
                    return owner.periodType.onNext(.all)
                }
                owner.periodType.onNext(
                    .byRange(
                        startDate.mmddyyyyString("/"),
                        endDate?.mmddyyyyString("/") ?? ""
                    )
                )
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnCancelCalendar(_ input: Input) {
        input.selectedCancelCalendar
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.periodType.onNext(.all)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Network data subscribers

extension SalesViewModel {
    
    private func collectionViewSubscribers() {
        subscribeOnOrdersSalesData()
        subscribeOnRefundsSalesData()
    }
    
    private func subscribeOnOrdersSalesData() {
        fetchOrdersSalesData()
            .withUnretained(self)
        // Save products count
            .do(onNext: { owner, dto in
                let productsCount = dto.count
                owner.productsCount.onNext(productsCount)
            })
            .withLatestFrom(ordersDataStorage.asDriverOnErrorJustComplete()) { (arg0, storage) in
                let (owner, dto) = arg0
                return (owner, dto, storage)
            }
        // Save data to storage
            .do(onNext: { owner, dto, storage in
                var storage = storage
                storage.append(contentsOf: dto.results)
                owner.ordersDataStorage.onNext(storage)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnRefundsSalesData() {
        fetchRefundsSalesData()
            .withUnretained(self)
        // Save products count
            .do(onNext: { owner, dto in
                let productsCount = dto.count
                owner.productsCount.onNext(productsCount)
            })
            .withLatestFrom(refundsDataStorage.asDriverOnErrorJustComplete()) { (arg0, storage) in
                let (owner, dto) = arg0
                return (owner, dto, storage)
            }
        // Save data to storage
            .do(onNext: { owner, dto, storage in
                var storage = storage
                storage.append(contentsOf: dto.results)
                owner.refundsDataStorage.onNext(storage)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: Make collection data

extension SalesViewModel {
    private func makeCollectionData() {
        Driver.merge(makeOrdersCollectionData(), makeRefundsCollectionData())
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                self.isShowPaginatedLoader.onNext(false)
            })
            .drive(collectionDataStorage)
            .disposed(by: disposeBag)
    }
    
}

// MARK: Make orders collection data

extension SalesViewModel {
    
    private func makeOrdersCollectionData() -> Driver<[ProductsSectionModel]> {
        ordersDataStorage
            .asDriverOnErrorJustComplete()
            .flatMapLatest(
                weak: self,
                selector: { owner, orders in
                    Observable.just(
                        orders.map { order in
                            // Get marketplace by identifier
                            owner.marketplacesUseCase
                                .getMarketplaceById(id: order.marketplace)
                                .map { marketplace in
                                    return (order, marketplace)
                                }
                        })
                    .flatMap { observables in
                        Observable.combineLatest(observables)
                            .map { $0.map { $0 } }
                    }
                    .asDriverOnErrorJustComplete()
                }
            )
            .withUnretained(self)
            .map { (owner, productMarketplaceArray) in
                productMarketplaceArray.map { order, markeplace in
                    return .init(
                        model: .defaultSection(
                            header: "",
                            footer: ""
                        ),
                        items: [
                            .main(
                                owner.makeOrderMainCellInput(order)),
                            .contentCell(
                                owner.makeOrderContentCellInput(
                                    order,
                                    marketplace: markeplace
                                )
                            ),
                            .showDetail
                        ]
                    )
                    
                }
                
            }
    }
    
    private func makeOrderMainCellInput(_ order: SalesOrdersDTO) -> ProductMainCell.Input {
        .init(
            imageUrl: URL(string: order.imageUrl ?? ""),
            titlesViewInput: .init(
                content: [
                    .init(
                        title: "Title:",
                        value: order.title
                    ),
                    .init(
                        title: "SKU:",
                        value: order.sellerSku
                    ),
                    .init(
                        title: "ASIN:",
                        value: order.asin
                    ),
                    .init(
                        title: "Order:",
                        value: order.amazonOrderId
                    )
                ]
            )
        )
    }
    
    private func makeOrderContentCellInput(
        _ order: SalesOrdersDTO,
        marketplace: MarketplaceDTO
    ) -> ProductContentCell.Input {
        .init(
            firstRow: makeOrderContentFirstRowInput(
                order,
                marketplace: marketplace
            ),
            secondRow: makeOrderContentSecondRowInput(order),
            thirdRow: makeOrderContentThirdRowInput(order)
        )
    }
    
    private func makeOrderContentFirstRowInput(
        _ order: SalesOrdersDTO,
        marketplace: MarketplaceDTO
    ) -> [ProductViewInput] {
        let noteImageType: DefaultButton.ImageType = (order.note ?? "").isEmpty ? .notes : .noteAdded
        
        return [
            .init(
                title: "Marketplace",
                viewType: .titledMarketplace(
                    .init(
                        countryTitle: marketplace.countryCode,
                        counryCode:  marketplace.countryCode
                    )
                )
            ),
            .init(
                title: "Unit Price",
                viewType: .text(
                    order.currencySymbol + String(order.originalPrice.price)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "Gross Profit",
                viewType: .text(
                    order.currencySymbol + String(order.profit)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "Status",
                viewType: .image(.status(.init(rawValue: order.orderStatus)))
            ),
            .init(
                title: "Note",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(noteImageType),
                        action: { [weak self] in
                            guard let self else { return }
                            let alertInput = self.makeNoteAlertInput(
                                note: order.note ?? "",
                                orderId: order.id
                            )
                            self.showAlert.onNext(alertInput)
                        }
                    )
                )
            )
        ]
    }
    
    private func makeOrderContentSecondRowInput( _ order: SalesOrdersDTO) -> [ProductViewInput] {
        [
            .init(
                title: "Time & Date",
                viewType: .text(order.purchaseDate.dateTTimeToShort())
            ),
            .init(
                title: "Amazon Fees",
                viewType: .text(
                    order.currencySymbol + String(order.amzFees ?? 0)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "ROI",
                viewType: .text(
                    String(order.roi ?? 0.0)
                        .doubleDecimalString(2) + "%")
            ),
            .init(
                title: "Shipped To",
                viewType: .image(.shippingTo(.init(rawValue: order.shippingTo?.countryCode)))
            ),
            .init(
                title: "Add Info",
                viewType: .addInfo(
                    .init(
                        vatButtonConfig: .init(
                            title: "\(order.vatRate)% VAT",
                            style: .vat,
                            action: {
                                
                            }
                        ),
                        sellerCentralButtonConfig: .init(
                            title: "",
                            style: .image(.sellerCentral),
                            action: {
                                
                            }
                        ),
                        amazonButtonConfig: .init(
                            title: "",
                            style: .image(.amazon),
                            action: {
                                
                            }
                        )
                    )
                )
            )
        ]
    }
    
    
    private func makeOrderContentThirdRowInput( _ order: SalesOrdersDTO) -> [ProductViewInput] {
        [
            .init(
                title: "Units",
                viewType: .text(
                    String(order.quantityOrdered)
                )
            ),
            .init(
                title: "COG",
                viewType: .button(
                    .init(
                        title: order.currencySymbol + String(order.totalCog)
                            .doubleDecimalString(2),
                        style: .cog,
                        action: {
                            
                        }
                    )
                )
            ),
            .init(
                title: "Margin",
                viewType: .text(
                    String(order.margin ?? 0.0)
                        .doubleDecimalString(2) + "%"
                )
            ),
            .init(
                title: "Fulfillment",
                viewType: .image(.fulfillment(.init(rawValue: order.fulfillment)))
            ),
            .init(
                title: "",
                viewType: .spacer
            )
        ]
    }
    
}

// MARK: Make refunds collection data

extension SalesViewModel {
    
    private func makeRefundsCollectionData() -> Driver<[ProductsSectionModel]> {
        refundsDataStorage
            .asDriverOnErrorJustComplete()
            .flatMapLatest(
                weak: self,
                selector: { owner, refunds in
                    Observable.just(
                        refunds.map { refund in
                            // Get marketplace by identifier
                            owner.marketplacesUseCase
                                .getMarketplaceById(id: refund.marketplace)
                                .map { marketplace in
                                    return (refund, marketplace)
                                }
                        })
                    .flatMap { observables in
                        Observable.combineLatest(observables)
                            .map { $0.map { $0 } }
                    }
                    .asDriverOnErrorJustComplete()
                }
            )
            .withUnretained(self)
            .map { (owner, productMarketplaceArray) in
                productMarketplaceArray.map { refund, marketplace in
                    return .init(
                        model: .defaultSection(
                            header: "",
                            footer: ""
                        ),
                        items: [
                            .main(owner.makeRefundMainCellInput(refund)),
                            .contentCell(
                                owner.makeRefundContentCellInput(
                                    refund: refund,
                                    marketplace: marketplace
                                )
                            ),
                            .showDetail
                        ]
                    )
                    
                }
                
            }
    }
    
    private func makeRefundMainCellInput(_ refund: SalesRefundsDTO) -> ProductMainCell.Input {
        .init(
            imageUrl: URL(string: refund.imageUrl ?? ""),
            titlesViewInput: .init(
                content: [
                    .init(
                        title: "Title:",
                        value: refund.title
                    ),
                    .init(
                        title: "SKU:",
                        value: refund.sellerSku
                    ),
                    .init(
                        title: "ASIN:",
                        value: refund.asin
                    ),
                    .init(
                        title: "Order:",
                        value: refund.amazonOrderId
                    )
                ]
            )
        )
    }
    
    
    private func makeRefundContentFirstRow(
        refund: SalesRefundsDTO,
        marketplace: MarketplaceDTO
    ) -> [ProductViewInput] {
        let noteImageType: DefaultButton.ImageType = (refund.note ?? "").isEmpty ? .notes : .noteAdded
        
        return [
            .init(
                title: "Marketplace",
                viewType: .titledMarketplace(
                    .init(
                        countryTitle: marketplace.countryCode,
                        counryCode:  marketplace.countryCode
                    )
                )
            ),
            .init(
                title: "Unit Price",
                viewType: .text(
                    refund.currencySymbol + String(refund.originalPrice.price)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "Refund Cost",
                viewType: .text(
                    refund.currencySymbol + String(refund.refundСost)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "Note",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(noteImageType),
                        action: { [weak self] in
                            guard let self else { return }
                            let alertInput = self.makeNoteAlertInput(
                                note: refund.note ?? "",
                                orderId: refund.id
                            )
                            self.showAlert.onNext(alertInput)
                        }
                    )
                )
            )
        ]
    }
    
    private func makeRefundContentSecondRow(refund: SalesRefundsDTO) -> [ProductViewInput] {
        [
            .init(
                title: "Time & Date",
                viewType: .text(refund.refundDate.dateTTimeToShort())
            ),
            .init(
                title: "Amazon Fees",
                viewType: .text(
                    refund.currencySymbol + String(refund.amzFees ?? 0)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "Status",
                viewType: .image(.status(.init(rawValue: refund.orderStatus)))
            ),
            .init(
                title: "Add Info",
                viewType: .addInfo(
                    .init(
                        vatButtonConfig: .init(
                            title: "\(refund.vatRate)% VAT",
                            style: .vat,
                            action: {
                                
                            }
                        ),
                        sellerCentralButtonConfig: .init(
                            title: "",
                            style: .image(.sellerCentral),
                            action: {
                                
                            }
                        ),
                        amazonButtonConfig: .init(
                            title: "",
                            style: .image(.amazon),
                            action: {
                                
                            }
                        )
                    )
                )
            )
        ]
    }
    
    private func makeRefundContentThirdRow(refund: SalesRefundsDTO) -> [ProductViewInput] {
        [
            .init(
                title: "Units",
                viewType: .text(
                    String(refund.quantityOrdered)
                )
            ),
            .init(
                title: "COG",
                viewType: .button(
                    .init(
                        title: refund.currencySymbol + String(refund.totalCog)
                            .doubleDecimalString(2),
                        style: .cog,
                        action: {
                            
                        }
                    )
                )
            ),
            .init(
                title: "Fulfillment",
                viewType: .image(.fulfillment(.init(rawValue: refund.fulfillment)))
            ),
            .init(
                title: "",
                viewType: .spacer
            )
        ]
    }
    
    
    private func makeRefundContentCellInput(
        refund: SalesRefundsDTO,
        marketplace: MarketplaceDTO
    ) -> ProductContentCell.Input {
        .init(
            firstRow: makeRefundContentFirstRow(
                refund: refund,
                marketplace: marketplace
            ),
            secondRow: makeRefundContentSecondRow(refund: refund) ,
            thirdRow: makeRefundContentThirdRow(refund: refund)
        )
    }
    
}
// MARK: Make marketplaces data

extension SalesViewModel {
    
    private func makeMarketplacesData() -> Driver<[MarketplacesPopoverTVCell.Input]> {
        marketplacesUseCase
            .getMarketplaces()
            .asDriverOnErrorJustComplete()
            .map { marketplaces in
                var input = marketplaces.map { marketplace -> MarketplacesPopoverTVCell.Input in
                    return .init(
                        marketplace: .init(
                            countryTitle: marketplace.country.capitalized,
                            counryCode: marketplace.countryCode
                        )
                    )
                }
                input.append(.init(marketplace: TitledMarketplace.Input.allMarketplaces()))
                return input
            }
    }
    
}

// MARK: Make alert inputs

extension SalesViewModel {
    
    private func makeNoteAlertInput(
        note: String,
        orderId: Int
    ) -> AlertManager.AlertType {
        let subscriber = BehaviorSubject<String>(value: "")
        
        return .note(
            .init(
                title: "Note",
                content: note,
                subscriber: subscriber,
                buttonsConfigs: [
                    .init(
                        title: "Cancel",
                        style: .primaryGray,
                        action: {
                         }
                    ),
                    .init(
                        title: "Ok",
                        style: .primary,
                        action: { [weak self] in
                            guard let self else { return }
                            self.updateNote(
                                note: subscriber,
                                id: orderId
                            )
                        }
                    )
                ]
            )
        )
    }
    
}

// MARK: - Requests

// MARK: Fetch data

extension SalesViewModel {
    
    private func fetchOrdersSalesData() -> Driver<SalesOrdersResultsDTO> {
        paginationCounter
            .compactMap({ $0 })
            .withLatestFrom(paginatedData) { paginationCounter, paginatedData in
                return (paginationCounter, paginatedData)
            }
            .withUnretained(self)
        // Change counter for paginatedData
            .do(onNext: { (owner, arg1) in
                let (paginationCounter, paginatedData) = arg1
                var paginatedDataVariable = paginatedData
                paginatedDataVariable.offset = paginationCounter
                owner.paginatedData.onNext(paginatedDataVariable)
            })
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete())
            .filter { $0.tableType == .orders }
            .withUnretained(self)
            .do(onNext: { owner, _  in
                owner.loadingStarted.onNext(())
            })
            .map { $1 }
            .flatMapLatest(weak: self) { owner, paginatedData in
                owner.salesRefundsUseCase
                    .getOrdersSales(paginatedData)
                    .trackActivity(owner.activityIndicator)
                    .take(until: owner.loadingStarted)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
    }
    
    private func fetchRefundsSalesData() -> Driver<SalesRefundsResultsDTO> {
        paginationCounter
            .compactMap({ $0 })
            .withLatestFrom(paginatedData) { paginationCounter, paginatedData in
                return (paginationCounter, paginatedData)
            }
            .withUnretained(self)
        // Change counter for paginatedData
            .do(onNext: { (owner, arg1) in
                let (paginationCounter, paginatedData) = arg1
                var paginatedDataVariable = paginatedData
                paginatedDataVariable.offset = paginationCounter
                owner.paginatedData.onNext(paginatedDataVariable)
            })
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete())
            .filter { $0.tableType == .refunds }
            .withUnretained(self)
            .do(onNext: { owner, _  in
                owner.loadingStarted.onNext(())
            })
            .map { $1 }
            .flatMapLatest(weak: self) { owner, paginatedData in
                owner.salesRefundsUseCase
                    .getRefundsSales(paginatedData)
                    .trackActivity(owner.activityIndicator)
                    .take(until: owner.loadingStarted)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
    }
    
}

// MARK: - Update note

extension SalesViewModel {
    
    private func updateNote(
        note: BehaviorSubject<String>,
        id: Int
    ) {
        note.asDriverOnErrorJustComplete()
            .flatMapFirst(weak: self) { owner, note in
                owner.noteUseCase
                    .updateNote(
                        .init(
                            id: id,
                            note: note
                        )
                    )
                    .trackActivity(owner.activityIndicator)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
}

extension SalesViewModel {
    struct Input {
        // viewDidAppear or swipe
        let reloadData: Driver<Void>
        // viewDidDisappear
        let screenDisappear: Driver<Void>
        // currently visible collection section
        let visibleSection: Driver<Int>
        // Country code selected
        let marketplaceSelected: Driver<String>
        // Calendar actions
        let selectedCalendarDates: Driver<(Date, Date?)>
        let selectedCancelCalendar: Driver<Void>
        
    }
    
    struct Output {
        let setupViewInput: Driver<SalesSetupView.Input>
        let collectionData: Driver<[ProductsSectionModel]>
        // Popovers
        let showCalendarPopover: Driver<CGPoint>
        let showMarketplacesPopover: Driver<CGPoint>
        // Popover data
        let marketplacesData: Driver<[MarketplacesPopoverTVCell.Input]>
        let startSelectedMarketplace: Driver<Int>
        // Bottom loader
        let isShowPaginatedLoader: Driver<Bool>
        // Trackers
        // Refresh control
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
        // Alert
        let alert: Driver<AlertManager.AlertType>
    }
    
}
