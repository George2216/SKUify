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

    private let showAlert = PublishSubject<AlertManager.AlertType>()

    // Dependencies
    private let navigator: InventoryNavigatorProtocol
    
    // Use case storage
    private let inventoryUseCase: Domain.InventoryUseCase
    private let marketplacesUseCase: Domain.MarketplacesReadUseCase
    private let noteUseCase: Domain.NoteUseCase
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
        self.noteUseCase = useCases.makeNoteInventoryUseCase()
        
        makeCollectionData()
        collectionViewSubscribers()
        paginatedDataScribers()
    }
    
    func transform(_ input: Input) -> Output {
        subscribeOnReloadData(input)
        subscribeOnScreenDisappear(input)
        subscribeOnReachedBottom(input)
        return Output(
            setupViewInput: makeSetupViewInput(),
            collectionData: collectionDataStorage.asDriverOnErrorJustComplete(), 
            isShowPaginatedLoader: isShowPaginatedLoader.asDriverOnErrorJustComplete(), 
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(),
            alert: showAlert.asDriverOnErrorJustComplete()
        )
    }
    
    private func reloadData() {
        // Clear storages
        ordersDataStorage.onNext([])
        buyBotImportsStorage.onNext([])
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
        // Save to paginated data
            .do(self) { (owner, arg1) in
                var (searchText, paginatedData) = arg1
                paginatedData.searchText = searchText
                owner.paginatedData.onNext(paginatedData)
            }
        // Clear storages
            .do(self) { owner, _ in
                owner.reloadData()
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnChangeCOGs() {
        changeCOGs
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { isNoCOGs, paginatedData in
                return (isNoCOGs, paginatedData)
            }
            .do(self) { (owner, arg1) in
                var (isNoCOGs, paginatedData) = arg1
                paginatedData.noCOGs = isNoCOGs
                owner.paginatedData.onNext(paginatedData)
            }
        // Clear storages
            .do(self) { owner, _ in
                owner.reloadData()
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnStockOrInactive() {
        changeStockOrInactive
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { isNoCOGs, paginatedData in
                return (isNoCOGs, paginatedData)
            }
            .do(self) { (owner, arg1) in
                var (isStockOrInactive, paginatedData) = arg1
                paginatedData.stockOrInactive = isStockOrInactive
                owner.paginatedData.onNext(paginatedData)
            }
        // Clear storages
            .do(self) { owner, _ in
                owner.reloadData()
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnWarningsOnly() {
        changeWarningsOnly
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { isNoCOGs, paginatedData in
                return (isNoCOGs, paginatedData)
            }
            .do(self) { (owner, arg1) in
                var (isWarningsOnly, paginatedData) = arg1
                paginatedData.onlyWarning = isWarningsOnly
                owner.paginatedData.onNext(paginatedData)
            }
        // Clear storages
            .do(self) { owner, _ in
                owner.reloadData()
            }
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
        // Save to paginated data
            .do(self) { (owner, arg1) in
                var (tableType, paginatedData) = arg1
                paginatedData.tableType = tableType
                owner.paginatedData.onNext(paginatedData)
            }
        // Clear storages
            .do(self) { (owner, _) in
                owner.reloadData()
            }
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
                    action: .simple({ [weak self] in
                        guard let self else { return }
                        self.tableType.onNext(.orders)
                    })
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
                    action: .simple({ [weak self] in
                        guard let self else { return }
                        self.tableType.onNext(.buyBotImports)
                    })
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
    private func subscribeOnReachedBottom(_ input: Input) {
        input.reachedBottom
        // Filter when product loading
            .withLatestFrom(activityIndicator.asDriver())
            .filter { !$0 }
            .withLatestFrom(paginationCounter.asDriverOnErrorJustComplete())
            .withLatestFrom(collectionDataStorage.asDriverOnErrorJustComplete()) { paginationCounter, collectionData in
                return (paginationCounter, collectionData.count)
            }
            .filter { paginationCounter, collectionCount in
                (paginationCounter ?? 0) <= collectionCount
            }
            .map({ $0.0 })
            .map({ (( $0 ?? 0) + 15) })
            .distinctUntilChanged()
            .shareElement(paginationCounter)
            .map({ _  in true })
            .drive(isShowPaginatedLoader)
            .disposed(by: disposeBag)
    }
    
    
    private func subscribeOnReloadData(_ input: Input) {
        input.reloadData
            .drive(with: self) { owner, _ in
                owner.reloadData()
            }
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
            .withLatestFrom(ordersDataStorage.asDriverOnErrorJustComplete()) { dto, storage in
                return (dto, storage)
            }
        // Save data to storage
            .do(self) { (owner, arg1) in
                var (dto, storage) = arg1
                storage.append(contentsOf: dto.results)
                owner.ordersDataStorage.onNext(storage)
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnBuyBotImportInventoryData() {
        fetchBuyBotImportsInventoryData()
            .withLatestFrom(buyBotImportsStorage.asDriverOnErrorJustComplete()) { dto, storage in
                return (dto, storage)
            }
        // Save data to storage
            .do(self) { (owner, arg1) in
                var (dto, storage) = arg1
                storage.append(contentsOf: dto.results)
                owner.buyBotImportsStorage.onNext(storage)
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: Make collection data

extension InventoryViewModel {
    
    private func makeCollectionData() {
        Driver.merge(makeOrdersCollectionData(), makeBuyBotImportsCollectionData())
            .do(self) { owner, _ in
                owner.isShowPaginatedLoader.onNext(false)
            }
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
            .map(self) { (owner, productMarketplaceArray) in
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
                            )
                        ]
                        + owner.makeReplenishCellsInput(order.restocks)
                            .map { .contentCell($0) }
                        + [.showDetail]
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
                title: "Amazon fees",
                viewType: .text(currencySymbol + order.amzFees.toUnwrappedString())
            ),
            .init(
                title: "ROI",
                viewType: .text(order.roi.toUnwrappedString() + "%")
            ),
            .init(
                title: "Note",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(noteImageType),
                        action: .simple({ [weak self] in
                            guard let self else { return }
                            let alertInput = self.makeNoteAlertInput(
                                note: order.note ?? "",
                                orderId: order.id
                            )
                            self.showAlert.onNext(alertInput)
                        })
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
                    order.originalPrice.price.toString()
                )
            ),
            .init(
                title: "COG",
                viewType: .button(
                    .init(
                        title: currencySymbol + order.cog.toString(),
                        style: .cog,
                        action: .simple({ [weak self] in
                            guard let self else { return }
                            let cogInput = order.toCOGInputModel(.inventory)
                            self.navigator.toCOG(cogInput)
                        })
                    )
                )
            ),
            .init(
                title: "Margin",
                viewType: .text(
                    order.margin.toUnwrappedString() + "%"
                )
            ),
            .init(
                title: "Add Info",
                viewType: .addInfo(
                    .init(
                        vatButtonConfig: .init(
                            title: "\(order.vatRate)% VAT",
                            style: .vat,
                            action: .simple({
                                
                            })
                        ),
                        sellerCentralButtonConfig: .init(
                            title: "",
                            style: .image(.sellerCentral),
                            action: .simple({
                                
                            })
                        ),
                        amazonButtonConfig: .init(
                            title: "",
                            style: .image(.amazon),
                            action: .simple({
                                
                            })
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
                    currencySymbol + order.profit.toUnwrappedString()
                )
            ),
            .init(
                title: "Fulfillment",
                viewType: .image(.fulfillment(.init(rawValue: order.fulfillment)))
            ),
            .init(
                title: "Replenish",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(.add),
                        action: .simple({ [weak self] in
                            guard let self else { return }
                            let cogInput = order.toCOGInputModel(.newReplenish)
                            self.navigator.toCOG(cogInput)
                        })
                    )
                )
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
            .map(self) { (owner, productMarketplaceArray) in
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
        let noteImageType: DefaultButton.ImageType = (bbImport.note ?? "").isEmpty ? .notes : .noteAdded

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
                    currencySymbol + bbImport.amzFees.toUnwrappedString())
                
            ),
            .init(
                title: "ROI",
                viewType: .text(bbImport.roi.toUnwrappedString() + "%")
            ),
            .init(
                title: "Note",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(noteImageType),
                        action: .simple({ [weak self] in
                            guard let self else { return }
                            let alertInput = self.makeNoteAlertInput(
                                note: bbImport.note ?? "",
                                orderId: bbImport.id
                            )
                            self.showAlert.onNext(alertInput)
                        })
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
                viewType: .text(currencySymbol + bbImport.originalPrice.price.toString())
            ),
            .init(
                title: "COG",
                viewType: .text(currencySymbol + bbImport.cog.toUnwrappedString())
            ),
            .init(
                title: "Margin",
                viewType: .text(bbImport.margin.toUnwrappedString() + "%")
            ),
            .init(
                title: "Settings",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(.tax),
                        action: .simple({ [weak self] in
                            guard let self else { return }
                            self.navigator.toSettingsCOG(bbImport.toCOGSettingsInputModel())
                        })
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
                viewType: .text(currencySymbol + bbImport.profit.toUnwrappedString())
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
                        action: .simple({
                            
                        })
                    )
                )
            )
        ]
    }
    
    private func makeReplenishCellsInput(_ orders: [[InventoryOrderDTO]]) -> [ProductContentCell.Input] {
        orders.compactMap { orders in
            orders.first
        }
        .map { order in
            return .init(
                title: "Replenished: \(order.dateAdded.toDate()?.ddMMMMyyyyString(" ") ?? "")",
                firstRow: makeReplenishFirstRowInput(order),
                secondRow: makeReplenishSecondRowInput(order),
                thirdRow: makeReplenishThirdRowInput(order)
            )
        }
    }
    
    private func makeReplenishFirstRowInput(_ order: InventoryOrderDTO) -> [ProductViewInput] {
        [
            .init(
                title: "Stock",
                viewType: .text(
                    String(order.currentStock)
                )
            ),
            .init(
                title: "COG",
                viewType: .button(
                    .init(
                        title: order.originalPrice.currency + order.cog.toString(),
                        style: .cog,
                        action: .simple({ [weak self] in
                            guard let self else { return }
                            let cogInput = order.toCOGInputModel(.inventory)
                            self.navigator.toCOG(cogInput)
                        })
                    )
                )
            ),
            .init(
                title: "Add Info",
                viewType: .addInfo(
                    .init(
                        vatButtonConfig: .init(
                            title: "\(order.vatRate)% VAT",
                            style: .vat,
                            action: .simple({
                                
                            })
                        ),
                        sellerCentralButtonConfig: .init(
                            title: "",
                            style: .image(.sellerCentral),
                            action: .simple({
                                
                            })
                        ),
                        amazonButtonConfig: .init(
                            title: "",
                            style: .image(.amazon),
                            action: .simple({
                                
                            })
                        )
                    )
                )
            )
        ]
    }
    
    private func makeReplenishSecondRowInput(_ order: InventoryOrderDTO) -> [ProductViewInput] {
        [
            .init(
                title: "ROI",
                viewType: .text(order.roi.toUnwrappedString() + "%")
            ),
            .init(
                title: "Margin",
                viewType: .text(
                    order.margin.toUnwrappedString() + "%"
                )
            ),
            .init(
                title: "", 
                viewType: .spacer
            )
        ]
    }
    
    private func makeReplenishThirdRowInput(_ order: InventoryOrderDTO) -> [ProductViewInput] {
        let currencySymbol = order.originalPrice.currency
        let noteImageType: DefaultButton.ImageType = (order.note ?? "").isEmpty ? .notes : .noteAdded
        return [
            .init(
                title: "Gross Profit",
                viewType: .text(
                    currencySymbol + order.profit.toUnwrappedString()
                )
            ),
            .init(
                title: "Note",
                viewType: .button(
                    .init(
                        title: "",
                        style: .image(noteImageType),
                        action: .simple({ [weak self] in
                            guard let self else { return }
                            let alertInput = self.makeNoteAlertInput(
                                note: order.note ?? "",
                                orderId: order.id
                            )
                            self.showAlert.onNext(alertInput)
                        })
                    )
                )
            ),
            .init(
                title: "",
                viewType: .spacer
            )
        ]
    }
    
}

// MARK: Make alert inputs

extension InventoryViewModel {
    
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
                        action: .simple({ })
                    ),
                    .init(
                        title: "Ok",
                        style: .primary,
                        action: .simple({ [weak self] in
                            guard let self else { return }
                            self.updateNote(
                                note: subscriber,
                                id: orderId
                            )
                        })
                    )
                ]
            )
        )
    }
    
}

// MARK: - Requests

// MARK: Fetch collection data

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
        // Sending an event indicating the start of loading for orders so that in case the loading for BuyBotImport is not yet finished, it can be ignored.
            .do(self) { owner, _  in
                owner.loadingStarted.onNext(())
            }
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
        // Sending an event indicating the start of loading for BuyBotImport, so that in case the loading for orders is not yet finished, it can be ignored.
            .do(self) { owner, _  in
                owner.loadingStarted.onNext(())
            }
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

// MARK: - Update note

extension InventoryViewModel {
    
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
                    .trackComplete(
                        owner.errorTracker,
                        message: "The note has been updated"
                    )
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .do(self) { owner, _ in
                owner.reloadData()
            }
            .drive()
            .disposed(by: disposeBag)
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
        let reachedBottom: Driver<Void>
    }
    
    struct Output {
        let setupViewInput: Driver<InventorySetupView.Input>
        let collectionData: Driver<[ProductsSectionModel]>
        // Bottom loader
        let isShowPaginatedLoader: Driver<Bool>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
        // Alert
        let alert: Driver<AlertManager.AlertType>
    }
    
}
