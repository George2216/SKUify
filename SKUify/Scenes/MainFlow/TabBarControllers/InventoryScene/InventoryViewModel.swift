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
    private let disposeBag = DisposeBag()
    
    private let paginatedData = BehaviorSubject<InventoryPaginatedModel>(value: .base())
    
    private let isShowPaginatedLoader = PublishSubject<Bool>()

    private let tableType = BehaviorSubject<InventoryTableType>(value: .orders)
    
    private let paginationCounter = BehaviorSubject<Int?>(value: nil)
    private let productsCount = BehaviorSubject<Int>(value: 0)

    // MARK: - Data storages
    // Collection data storage
    private let collectionDataStorage = BehaviorSubject<[ProductsSectionModel]>(value: [])
    
    // DTO data storages
    private let ordersDataStorage = BehaviorSubject<[InventoryOrderDTO]>(value: [])
    private let buyBotImportsStorage = BehaviorSubject<[InventoryBuyBotImportsDTO]>(value: [])
    
    // MARK: - Start loading events for a specific table type
    
    private let loadingStarted = PublishSubject<Void>()

    // MARK: - Setup view actions
    
    private let searchTextChanged = PublishSubject<String>()
    private let changeCOGs = PublishSubject<Bool>()
    private let changeStockOrInactive = PublishSubject<Bool>()
    private let changeWarningsOnly = PublishSubject<Bool>()

    // Dependencies
    private let navigator: InventoryNavigatorProtocol
    
    // Use case storage
    private let inventoryUseCase: Domain.InventoryUseCase
    private let marketplacesUseCase: Domain.MarketplacesReadUseCase

    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: InventoryUseCases,
        navigator: InventoryNavigatorProtocol
    ) {
        self.navigator = navigator
        self.inventoryUseCase = useCases.makeInventoryUseCase()
        self.marketplacesUseCase = useCases.makeMarketplacesUseCase()
        
        makeCollectionData()
        collectionViewSubscribers()
        paginatedDataScribers()
    }
    
    func transform(_ input: Input) -> Output {
        subscribeOnReloadData(input)
        subscribeOnScreenDisappear(input)
        subscribeOnVisibleSection(input)
        return Output(
            setupViewInput: makeSetupViewInput(),
            collectionData: collectionDataStorage.asDriverOnErrorJustComplete(), 
            isShowPaginatedLoader: isShowPaginatedLoader.asDriverOnErrorJustComplete(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error)
        )
    }
    
    private func reloadData() {
        // Clear storages
        ordersDataStorage.onNext([])
        buyBotImportsStorage.onNext([])
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
        subscribeOnStockOrInactive()
        subscribeOnWarningsOnly()
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
    
    private func subscribeOnStockOrInactive() {
        changeStockOrInactive
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { isNoCOGs, paginatedData in
                return (isNoCOGs, paginatedData)
            }
            .withUnretained(self)
            .do(onNext: { (owner, arg1) in
                var (isStockOrInactive, paginatedData) = arg1
                paginatedData.stockOrInactive = isStockOrInactive
                owner.paginatedData.onNext(paginatedData)
            })
        // Clear storages
            .do(onNext: { owner, _ in
                owner.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnWarningsOnly() {
        changeWarningsOnly
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { isNoCOGs, paginatedData in
                return (isNoCOGs, paginatedData)
            }
            .withUnretained(self)
            .do(onNext: { (owner, arg1) in
                var (isWarningsOnly, paginatedData) = arg1
                paginatedData.onlyWarning = isWarningsOnly
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
                    debounce: 400,
                    textObserver: { [weak self] text in
                        guard let self else { return }
                        self.searchTextChanged.onNext(text)
                    }
                ),
                switchesViewInput: .init(
                    inactiveTitledSwitchInput: .init(
                        title: "Include out of stock or inactive",
                        switchState: false,
                        switchChanged: { [weak self] isOn in
                            guard let self else { return }
                            self.changeStockOrInactive.onNext(isOn)
                        }),
                    noCOGsTiledSwitchInput: .init(
                        title: "No COGs",
                        switchState: false,
                        switchChanged: { [weak self] isOn in
                            guard let self else { return }
                            self.changeCOGs.onNext(isOn)
                        }),
                    warningsTitledSwitchInput: .init(
                        title: "Warnings only",
                        switchState: false,
                        switchChanged: { [weak self] isOn in
                            guard let self else { return }
                            self.changeWarningsOnly.onNext(isOn)
                        }
                    )
                )
            )
        )
    }
    
}

// MARK: Subscribers from Input

extension InventoryViewModel {
    
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
    
}

// MARK: - Network data subscribers

extension InventoryViewModel {
    
    private func collectionViewSubscribers() {
        subscribeOnOrdersInventoryData()
        subscribeOnBuyBotImportInventoryData()
    }
    
    private func subscribeOnOrdersInventoryData() {
        fetchOrdersInventoryData()
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
    
    private func subscribeOnBuyBotImportInventoryData() {
        fetchBuyBotImportsInventoryData()
            .withUnretained(self)
        // Save products count
            .do(onNext: { owner, dto in
                let productsCount = dto.count
                owner.productsCount.onNext(productsCount)
            })
            .withLatestFrom(buyBotImportsStorage.asDriverOnErrorJustComplete()) { (arg0, storage) in
                let (owner, dto) = arg0
                return (owner, dto, storage)
            }
        // Save data to storage
            .do(onNext: { owner, dto, storage in
                var storage = storage
                storage.append(contentsOf: dto.results)
                owner.buyBotImportsStorage.onNext(storage)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: Make collection data

extension InventoryViewModel {
    
    private func makeCollectionData() {
        Driver.merge(makeOrdersCollectionData(), makeBuyBotImportsCollectionData())
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                self.isShowPaginatedLoader.onNext(false)
            })
            .drive(collectionDataStorage)
            .disposed(by: disposeBag)
    }
    
}


// MARK: Make orders collection data

extension InventoryViewModel {
    
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
    
    private func makeOrderMainCellInput(_ order: InventoryOrderDTO) -> ProductMainCell.Input {
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
                    )
                ]
            )
        )
    }
    
    private func makeOrderContentCellInput(
        _ order: InventoryOrderDTO,
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
        _ order: InventoryOrderDTO,
        marketplace: MarketplaceDTO
    ) -> [ProductViewInput] {
        let currencySymbol = order.originalPrice.currency
        
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
                title: "Amazon fees",
                viewType: .text(
                    currencySymbol + String(order.amzFees ?? 0.0)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "ROI",
                viewType: .text(
                    String(order.roi ?? 0.0)
                        .doubleDecimalString(2) + "%"
                )
            ),
            .init(
                title: "Notes",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(.notes),
                        action: {}
                    )
                )
            )
        ]
    }
    
    private func makeOrderContentSecondRowInput( _ order: InventoryOrderDTO) -> [ProductViewInput] {
        let currencySymbol = order.originalPrice.currency

        return [
            .init(
                title: "Price",
                viewType: .text(
                    currencySymbol +
                    String(order.originalPrice.price)
                    .doubleDecimalString(2)
                )
            ),
            .init(
                title: "COG",
                viewType: .button(
                    .init(
                        title: currencySymbol + String(order.cog)
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
    
    
    private func makeOrderContentThirdRowInput( _ order: InventoryOrderDTO) -> [ProductViewInput] {
        let currencySymbol = order.originalPrice.currency

       return [
            .init(
                title: "Stock",
                viewType: .text(
                    String(order.currentStock)
                )
            ),
            .init(
                title: "Gross Profit",
                viewType: .text(
                    currencySymbol +
                    String(order.profit ?? 0.0)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "Fulfillment",
                viewType: .image(.fulfillment(.init(rawValue: order.fulfillment)))
            ),
            .init(
                title: "Replenish",
                viewType: .button(.init(title: "", style: .image(.add)))
            )
        ]
    }
    
}

// MARK: Make buy bot imports collection data


extension InventoryViewModel {
    
    private func makeBuyBotImportsCollectionData() -> Driver<[ProductsSectionModel]> {
        buyBotImportsStorage
            .asDriverOnErrorJustComplete()
            .flatMapLatest(
                weak: self,
                selector: { owner, bbImports in
                    Observable.just(
                        bbImports.map { bbImport in
                            // Get marketplace by identifier
                            owner.marketplacesUseCase
                                .getMarketplaceById(id: bbImport.marketplace)
                                .map { marketplace in
                                    return (bbImport, marketplace)
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
                productMarketplaceArray.map { bbImport, markeplace in
                    return .init(
                        model: .defaultSection(
                            header: "",
                            footer: ""
                        ),
                        items: [
                            .main(
                                owner.makeBuyBotImportsMainCellInput(bbImport)
                            ),
                            .contentCell(
                                owner.makeBuyBotImportsContentCellInput(
                                    bbImport,
                                    marketplace: markeplace
                                )
                            ),
                            .showDetail
                        ]
                    )
                    
                }
                
            }
    }
    
    private func makeBuyBotImportsMainCellInput(_ bbImport: InventoryBuyBotImportsDTO) -> ProductMainCell.Input {
        .init(
            imageUrl: URL(string: bbImport.imageUrl ?? ""),
            titlesViewInput: .init(
                content: [
                    .init(
                        title: "Title:",
                        value: bbImport.title
                    ),
                    .init(
                        title: "SKU:",
                        value: bbImport.sellerSku
                    ),
                    .init(
                        title: "ASIN:",
                        value: bbImport.asin
                    )
                ]
            )
        )
    }
    
    private func makeBuyBotImportsContentCellInput(
        _ bbImport: InventoryBuyBotImportsDTO,
        marketplace: MarketplaceDTO
    ) -> ProductContentCell.Input {
        .init(
            firstRow: makeBuyBotImportsContentFirstRowInput(
                bbImport,
                marketplace: marketplace
            ),
            secondRow: makeBuyBotImportsContentSecondRowInput(bbImport),
            thirdRow: makeBuyBotImportsContentThirdRowInput(bbImport)
        )
    }
    
    private func makeBuyBotImportsContentFirstRowInput(
        _ bbImport: InventoryBuyBotImportsDTO,
        marketplace: MarketplaceDTO
    ) -> [ProductViewInput] {
        let currencySymbol = bbImport.originalPrice.currency
        
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
                title: "Amazon fees",
                viewType: .text(
                    currencySymbol + String(bbImport.amzFees ?? 0.0)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "ROI",
                viewType: .text(
                    String(bbImport.roi ?? 0.0)
                        .doubleDecimalString(2) + "%"
                )
            ),
            .init(
                title: "Notes",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(.notes),
                        action: {}
                    )
                )
            )
        ]
    }
    
    private func makeBuyBotImportsContentSecondRowInput( _ bbImport: InventoryBuyBotImportsDTO) -> [ProductViewInput] {
        let currencySymbol = bbImport.originalPrice.currency

        return [
            .init(
                title: "Price",
                viewType: .text(
                    currencySymbol +
                    String(bbImport.originalPrice.price)
                    .doubleDecimalString(2)
                )
            ),
            .init(
                title: "COG",
                viewType: .text(
                    currencySymbol + String(bbImport.cog)
                    .doubleDecimalString(2)
                )
            ),
            .init(
                title: "Margin",
                viewType: .text(
                    String(bbImport.margin ?? 0.0)
                        .doubleDecimalString(2) + "%"
                )
            ),
            .init(
                title: "Settings",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(.tax),
                        action: {
                            
                        }
                    )
                )
            )
        ]
    }
    
    
    private func makeBuyBotImportsContentThirdRowInput(_ bbImport: InventoryBuyBotImportsDTO) -> [ProductViewInput] {
        let currencySymbol = bbImport.originalPrice.currency

       return [
            .init(
                title: "Stock",
                viewType: .text(
                    String(bbImport.stock)
                )
            ),
            .init(
                title: "Profit",
                viewType: .text(
                    currencySymbol +
                    String(bbImport.profit ?? 0.0)
                        .doubleDecimalString(2)
                )
            ),
            .init(
                title: "Fulfillment",
                viewType: .image(.fulfillment(.init(rawValue: bbImport.fulfillment)))
            ),
            .init(
                title: "Delete",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(.delete),
                        action: {
                            
                        }
                    )
                )
            )
        ]
    }
    
}

// MARK: Fetch data

extension InventoryViewModel {
    
    private func fetchOrdersInventoryData() -> Driver<InventoryOrdersResultsDTO> {
        paginationCounter
            .compactMap({ $0 })
            .withLatestFrom(paginatedData) { paginationCounter, paginatedData in
                return (paginationCounter, paginatedData)
            }
            .withUnretained(self)
        // Change counter for paginatedData
            .do(onNext: { (owner, arg1) in
                let (paginationCounter, paginatedData) = arg1
                var updatedPaginatedData = paginatedData
                updatedPaginatedData.offset = paginationCounter
                owner.paginatedData.onNext(updatedPaginatedData)
            })
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete())
            .filter { $0.tableType == .orders }
            .withUnretained(self)
        // Sending an event indicating the start of loading for orders so that in case the loading for BuyBotImport is not yet finished, it can be ignored.
            .do(onNext: { owner, _  in
                owner.loadingStarted.onNext(())
            })
            .map { $1 }
            .flatMapLatest(weak: self) { owner, paginatedData in
                owner.inventoryUseCase
                    .getOrdersInventory(paginatedData)
                    .trackActivity(owner.activityIndicator)
                    .take(until: owner.loadingStarted)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
    }
    
    private func fetchBuyBotImportsInventoryData() -> Driver<InventoryBuyBotImportsResultsDTO> {
        paginationCounter
            .compactMap({ $0 })
            .withLatestFrom(paginatedData) { paginationCounter, paginatedData in
                return (paginationCounter, paginatedData)
            }
            .withUnretained(self)
        // Change counter for paginatedData
            .do(onNext: { (owner, arg1) in
                let (paginationCounter, paginatedData) = arg1
                var updatedPaginatedData = paginatedData
                updatedPaginatedData.offset = paginationCounter
                owner.paginatedData.onNext(updatedPaginatedData)
            })
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete())
            .filter { $0.tableType == .buyBotImports }
            .withUnretained(self)
        // Sending an event indicating the start of loading for BuyBotImport, so that in case the loading for orders is not yet finished, it can be ignored.
            .do(onNext: { owner, _  in
                owner.loadingStarted.onNext(())
            })
            .map { $1 }
            .flatMapLatest(weak: self) { owner, paginatedData in
                owner.inventoryUseCase
                    .getBuyBotImportsInventory(paginatedData)
                    .trackActivity(owner.activityIndicator)
                    .take(until: owner.loadingStarted)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
    }

}

// MARK: - Input, Output

extension InventoryViewModel {
    struct Input {
        // viewDidAppear or swipe
        let reloadData: Driver<Void>
        // viewDidDisappear
        let screenDisappear: Driver<Void>
        // currently visible collection section
        let visibleSection: Driver<Int>
    }
    
    struct Output {
        let setupViewInput: Driver<InventorySetupView.Input>
        let collectionData: Driver<[ProductsSectionModel]>
        // Bottom loader
        let isShowPaginatedLoader: Driver<Bool>
        // Trackers
        // Refresh control
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
    }
    
}
