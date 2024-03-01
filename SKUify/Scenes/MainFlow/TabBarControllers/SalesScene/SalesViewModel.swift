//
//  SalesViewModel2.swift
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
    
    private let collectionDataStorage = BehaviorSubject<[SalesSectionModel]>(value: [])
    
    private let selectOrders = PublishSubject<Void>()
    private let selectRefunds = PublishSubject<Void>()

    private let tableType = BehaviorSubject<SalesTableType>(value: .orders)
    private let periodType = BehaviorSubject<SalesPeriodType>(value: .all)
    private let marketplaceType = BehaviorSubject<SalesMarketplaceType>(value: .all)
    
    private let paginationCounter = BehaviorSubject<Int?>(value: nil)
    private let productsCount = BehaviorSubject<Int>(value: 0)
    
    private let ordersDataStorage = BehaviorSubject<[SalesOrdersDTO]>(value: [])
    private let refundsDataStorage = BehaviorSubject<[SalesRefundsDTO]>(value: [])
    
    // MARK: - Setup view actions
    
    private let searchTextChanged = PublishSubject<String>()
    private let tapOnCalendar = PublishSubject<CGPoint>()
    private let tapOnMarketplaces = PublishSubject<CGPoint>()
    private let changeCOGs = PublishSubject<Bool>()
    
    // Dependencies
    private let navigator: SalesNavigatorProtocol
    
    // Use case storage
    private let salesRefundsUseCase: Domain.SalesRefundsUseCase
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: SalesUseCases,
        navigator: SalesNavigatorProtocol
    ) {
        self.navigator = navigator
        self.salesRefundsUseCase = useCases.makeSalesRefundsUseCase()
        
        paginatedDataScribers()
        collectionViewSubscribers()
    }
    
    func transform(_ input: Input) -> Output {
        subscribeOnVisibleSection(input)
        return Output(
            setupViewInput: makeSetupViewInput(),
            collectionData: makeCollectionData(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error)
        )
    }
    
    private func reloadData() {
        // Clear storages
        ordersDataStorage.onNext([])
        refundsDataStorage.onNext([])
        // Remove products count
        productsCount.onNext(0)
        // Reload data
        paginationCounter.onNext(nil)
    }
    
    private func paginatedDataScribers() {
        subscribeOnSelectRefunds()
        subscribeOnSelectOrders()
        subscribeOnTableTypeChanged()
        subscribeOnSearchTextChanged()
        subscribeOnPaginatedCounter()
    }
    
    private func subscribeOnSelectRefunds() {
        selectOrders
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.tableType.onNext(.orders)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnSelectOrders() {
        selectRefunds
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .do(onNext: { owner, _ in
                owner.tableType.onNext(.refunds)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnTableTypeChanged() {
        tableType
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
    
    private func subscribeOnSearchTextChanged() {
        searchTextChanged
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { searchText, paginatedData in
                return (searchText, paginatedData)
            }
            .withUnretained(self)
            .do(onNext: { (owner, arg1) in
                var (searchText, paginatedData) = arg1
                paginatedData.searchText = searchText
                owner.paginatedData.onNext(paginatedData)
            })
            .do(onNext: { owner, _ in
                owner.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnPaginatedCounter() {
        paginationCounter
            .asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete()) { paginationCounter, paginatedData in
                return (paginationCounter, paginatedData)
            }
            .withUnretained(self)
            .do(onNext: { (owner, arg1) in
                var (paginationCounter, paginatedData) = arg1
                paginatedData.offset = paginationCounter
                owner.paginatedData.onNext(paginatedData)
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
                        self.selectOrders.onNext(())
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
                        self.selectRefunds.onNext(())
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
        
        newPaginatedCounterDriver
            .drive(paginationCounter)
            .disposed(by: disposeBag)

    }
    
}

// MARK: Collection view subscribers

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
    
    private func makeCollectionData() -> Driver<[SalesSectionModel]> {
        Driver.merge(makeOrdersCollectionData(), makeRefundsCollectionData())
            .do(onNext: { [weak self] data in
                guard let self else { return }
                self.collectionDataStorage.onNext(data)
            })
    }
    
    private func makeOrdersCollectionData() -> Driver<[SalesSectionModel]> {
        ordersDataStorage
            .compactMap { $0 }
            .withUnretained(self)
            .map { owner, orders  in
                orders.map { order -> SalesSectionModel in
                    return .init(
                        model: .defaultSection(
                            header: "",
                            footer: ""
                        ),
                        items: [
                            .orders(
                                .init(
                                    mainViewInput: .init(
                                        imageUrl: URL(string: order.image_url ?? ""),
                                        titlesViewInput: .init(
                                            content: [
                                                .init(
                                                    title: "Title:",
                                                    value: order.title
                                                ),
                                                .init(
                                                    title: "SKU:",
                                                    value: order.seller_sku
                                                ),
                                                .init(
                                                    title: "ASIN:",
                                                    value: order.asin
                                                ),
                                                .init(
                                                    title: "Order:",
                                                    value: order.order__amazon_order_id
                                                )
                                            ]
                                        )
                                    )
                                )
                            )
                        ]
                    )
                    
                }
            }
            .asDriverOnErrorJustComplete()
    }
    
    private func makeRefundsCollectionData() -> Driver<[SalesSectionModel]> {
        refundsDataStorage
            .compactMap { $0 }
            .withUnretained(self)
            .map { owner, refunds in
                refunds.map { refund -> SalesSectionModel in
                    return .init(
                        model: .defaultSection(
                            header: "",
                            footer: ""
                        ),
                        items: [
                            .refunds(
                                .init(
                                    mainViewInput: .init(
                                        imageUrl: URL(string: refund.image_url ?? ""),
                                        titlesViewInput: .init(
                                            content: [
                                                .init(
                                                    title: "Title:",
                                                    value: refund.title
                                                ),
                                                .init(
                                                    title: "SKU:",
                                                    value: refund.seller_sku
                                                ),
                                                .init(
                                                    title: "ASIN:",
                                                    value: refund.asin
                                                )
                                            ]
                                        )
                                    )
                                )
                            )
                        ]
                    )
                    
                }
            }
            .asDriverOnErrorJustComplete()
    }

    
}

// MARK: Fetch data

extension SalesViewModel {

    private func fetchOrdersSalesData() -> Driver<SalesOrdersResultsDTO> {
        paginationCounter.asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete())
            .filter { $0.tableType == .orders }
            .flatMapLatest(weak: self) { owner, paginatedData in
                owner.salesRefundsUseCase
                    .getOrdersSales(paginatedData)
                    .trackActivity(owner.activityIndicator)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
    }
    
    private func fetchRefundsSalesData() -> Driver<SalesRefundsResultsDTO> {
        paginationCounter.asDriverOnErrorJustComplete()
            .withLatestFrom(paginatedData.asDriverOnErrorJustComplete())
            .filter { $0.tableType == .refunds }
            .flatMapLatest(weak: self) { owner, paginatedData in
                owner.salesRefundsUseCase
                    .getRefundsSales(paginatedData)
                    .trackActivity(owner.activityIndicator)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
    }
    
}

extension SalesViewModel {
    struct Input {
        let visibleSection: Driver<Int>
    }
    
    struct Output {
        let setupViewInput: Driver<SalesSetupView.Input>
        let collectionData: Driver<[SalesSectionModel]>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
    }
    
}



