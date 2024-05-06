//
//  COGSettingsViewModel.swift
//  SKUify
//
//  Created by George Churikov on 22.04.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class COGSettingsViewModel: COGBaseViewModel {

    private let disposeBag = DisposeBag()
    
    // Subscribers
    
    private let unitCostEditing = PublishSubject<String>()
    private let quantityEditing = PublishSubject<Int?>()
    private let purchasedFromEditing = PublishSubject<String>()
    private let bundledStateChenged = PublishSubject<Bool>()
    
    private let tapOnSave = PublishSubject<Void>()
    private let tapOnRecalculate = PublishSubject<Void>()
    
    private let cangedBBPImportStrategy = PublishSubject<BBPImportStrategy>()
    private let changedApplyToUnsoldInventory = PublishSubject<Bool>()
    
    private let showCalendarPopover = PublishSubject<CGPoint>()

    // Can be change only for ui update
    private let visibleDataStorage: BehaviorSubject<COGSettingsInputModel>
    // Changed data
    private let changedDataStorage: BehaviorSubject<COGSettingsInputModel>
    
    // Dependencies
    private let navigator: COGSettingsNavigatorProtocol
    
    // Use case storage
    
    private let cogsInformationUseCase: Domain.COGSInformationUseCase
    private let bbgImportStategyUseCase: Domain.COGBbpImoprtStategyUseCase
    private let cogSettingsUseCase: Domain.COGSettingsUseCase
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        input: COGSettingsInputModel,
        useCases: COGSettingsUseCases,
        navigator: COGSettingsNavigatorProtocol
    ) {
        self.navigator = navigator
        self.cogsInformationUseCase = useCases.makeCOGSInformationUseCase()
        self.bbgImportStategyUseCase = useCases.makeCOGBbpImoprtStategyUseCase()
        self.cogSettingsUseCase = useCases.makeCOGSettingsUseCase()
        
        self.visibleDataStorage = .init(value: input)
        self.changedDataStorage = .init(value: input)
        super.init()
        // Initialize models with complete data
        addSKUIfyDataToStorages(input)
        subscribtions()
    }
    
    override func transform(_ input: Input) -> Output {
        _ = super.transform(input)
        subscribeOnSelectedCalendarDate(input)
        
        return Output(
            title: makeTitle(),
            collectionData: makeCollectionData(),
            showCalendarPopover: showCalendarPopover.asDriverOnErrorJustComplete(),
            keyboardHeight: .empty(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error)
        )
    }
    
    private func makeTitle() -> Driver<String> {
        .just("COG Settings")
    }
    
    // MARK: - Make collection data
    
    private func makeCollectionData() -> Driver<[COGSectionModel]> {
        visibleDataStorage
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .map { owner, data in
                owner.makeCollectionData(data)
            }
    }
    
    
    private func makeCollectionData(_ data: COGSettingsInputModel) -> [COGSectionModel] {
        return [
            .init(
                model: .defaultSection(),
                items: [.main(makeMainCellInput(data))]
            ),
            .init(
                model: .defaultSection(),
                items: [
                    .purchaseDetail(
                        makePurchaseDetailCellInput(data)
                    )
                ]
            ),
            .init(
                model: .defaultSection(
                    header: "Please select the correct COGs to apply to ASIN",
                    footer: ""
                ),
                items: [
                    .importStrategy(makeSKUIfyCellInput(data))
                ]
            ),
            .init(
                model: .defaultSection(),
                items: [
                    .importStrategy(makeBBPCellInput(data))
                ]
            ),
            .init(
                model: .defaultSection(),
                items: [
                    .importStrategy(makeEditCellInput(data))
                ]
            ),
            .init(
                model: .defaultSection(),
                items: [
                    .applyToInventory(makeApplyToInventoryCellInput(data))
                ]
            )
        ]
    }
    
    private func makeMainCellInput(_ data: COGSettingsInputModel) -> COGMainCell.Input {
        .init(
            imageUrl: URL(string: data.imageUrl ?? ""),
            content: .init(
                content: [
                    .init(
                        title: "Title:",
                        value: data.title
                    ),
                    .init(
                        title: "SKU:",
                        value: data.sku
                    ),
                    .init(
                        title: "ASIN:",
                        value: data.asin
                    ),
                    .init(
                        title: "Price:",
                        value: data.currencySymbol + String(data.price)
                    ),
                    .init(
                        title: "Date Added:",
                        value: data.dataAdded.ddMMyyhmma("/")
                    )
                ]
            )
        )
    }
    
    private func makePurchaseDetailCellInput(_ data: COGSettingsInputModel) -> COGPurchaseDetailCell.Input {
        .init(
            content: [
                .titledView(
                    .init(
                        title: "Unit Cost (Inclusive of VAT)",
                        viewType: .textField(
                            .init(
                                style: .doubleBordered(data.currencySymbol),
                                text: data.unitCost.toUnwrappedString(),
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.unitCostEditing.onNext(text)
                                }
                            )
                        )
                        
                    )
                ),
                .titledView(
                    .init(
                        title: "Quantity",
                        viewType: .textField(
                            .init(
                                style: .intBordered,
                                text: data.quantity.stringOrEmpty(),
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.quantityEditing.onNext(Int(text))

                                }
                            )
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Purchased From",
                        viewType: .textField(
                            .init(
                                style: .bordered,
                                text: data.purchasedFrom ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.purchasedFromEditing.onNext(text)
                                }
                            )
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Date",
                        viewType: .button(
                            .init(
                                title: data.purchaseDate.ddMMyyyyString("/"),
                                style: .light,
                                action: .point({ [weak self] center in
                                    guard let self else { return }
                                    self.showCalendarPopover.onNext(center)
                                })
                            )
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Bundle",
                        viewType: .smallSwitch(
                            .init(
                                state: data.bundled,
                                switchChanged: { [weak self] isOn in
                                    guard let self else { return }
                                    self.bundledStateChenged.onNext(isOn)
                                }
                            )
                        )
                    )
                )
            ]
        )
    }
    
    private func makeSKUIfyCellInput(_ data: COGSettingsInputModel) -> COGImportStrategyCell.Input {
        let switchState = data.bbpImportStrategy == .skuify
        return makeImortStrategyCellInput(
            bbpImportStrategy: .skuify,
            currencySymbol: data.currencySymbol,
            unitCost: data.unitCost,
            price: data.price,
            switchState: switchState,
            data.skuifyItemData
        )
    }
    
    private func makeBBPCellInput(_ data: COGSettingsInputModel) -> COGImportStrategyCell.Input {
        let switchState = data.bbpImportStrategy == .bbp
        return makeImortStrategyCellInput(
            bbpImportStrategy: .bbp,
            currencySymbol: data.currencySymbol,
            unitCost: data.unitCost,
            price: data.price,
            switchState: switchState,
            data.bbpItemData
        )
    }
    
    private func makeEditCellInput(_ data: COGSettingsInputModel) -> COGImportStrategyCell.Input {
        let switchState = data.bbpImportStrategy == .edit
        return makeImortStrategyCellInput(
            bbpImportStrategy: .edit,
            currencySymbol: data.currencySymbol,
            unitCost: data.unitCost, 
            price: data.price,
            switchState: switchState,
            data.editItemData
        )
    }
    
    private func makeImortStrategyCellInput(
        bbpImportStrategy: BBPImportStrategy,
        currencySymbol: String,
        unitCost: Double?,
        price: Double?,
        switchState: Bool,
        _ data: COGSettingsItem
    ) -> COGImportStrategyCell.Input {
        
        return .init(
            content: [
                .titledSwith(
                    .init(
                        title: bbpImportStrategy.title,
                        config: .init(
                            state: switchState,
                            switchChanged: { [weak self] _ in
                                guard let self else { return }
                                self.cangedBBPImportStrategy.onNext(bbpImportStrategy)
                            }
                        )
                    )
                ),
                .titledViews([
                    .init(
                        title: "Direct Costs",
                        viewType: .titledLabels(
                            [
                                .init(
                                    title: "Bundling",
                                    value: currencySymbol + data.bundling.toUnwrappedString()
                                ),
                                .init(
                                    title: "Extra Fee",
                                    value: currencySymbol + data.extraFee.toUnwrappedString()
                                ),
                                .init(
                                    title: "Extra Fee %",
                                    value: data.extraFeePerc.toUnwrappedString() + "%"
                                ),
                                .init(
                                    title: "Handling",
                                    value: currencySymbol + data.handling.toUnwrappedString()
                                ),
                                .init(
                                    title: "Other",
                                    value: currencySymbol + data.other.toUnwrappedString()
                                ),
                                .init(
                                    title: "Packaging",
                                    value: currencySymbol + data.packaging.toUnwrappedString()
                                ),
                                .init(
                                    title: "Postage",
                                    value: currencySymbol + data.postage.toUnwrappedString()
                                ),
                                .init(
                                    title: "Prep Fee",
                                    value: currencySymbol + data.prepCentre.toUnwrappedString()
                                ),
                                .init(
                                    title: "VAT Free Postage",
                                    value: currencySymbol + data.vatFreePostage.toUnwrappedString()
                                )
                            ]
                        )
                    ),
                    .init(
                        title: "",
                        viewType: .boldTitledLabels(
                            [
                                .init(
                                    title: "Total Costs",
                                    value: currencySymbol + data.calculateTotalCosts(unitCost).toString()
                                ),
                                .init(
                                    title: "Gross Profit",
                                    value: currencySymbol + data.calculateGrossProfit(
                                        unitCost,
                                        price: price
                                    ).toString()
                                )
                            ]
                        )
                    )
                ]
                )
            ]
        )
    }
    
    private func makeApplyToInventoryCellInput(_ data: COGSettingsInputModel) -> COGApplyToInventoryCell.Input {
        .init(
            titledSwitchInput: .init(
                title: "Apply to ALL unsold inventory on this ASIN",
                switchState: data.applyToUnsoldInventory,
                switchChanged: { [weak self] isOn in
                    guard let self else { return }
                    self.changedApplyToUnsoldInventory.onNext(isOn)
                }
            ),
            buttonConfigs: [
                .init(
                    title: "Recalculate",
                    style: .primary,
                    action: .simple({ [weak self] in
                        guard let self else { return }
                        self.tapOnRecalculate.onNext(())
                    })
                ),
                .init(
                    title: "Save",
                    style: .primary,
                    action: data.bbpImportStrategy == .none
                    ? nil
                    : .simple({ [weak self] in
                        guard let self else { return }
                        self.tapOnSave.onNext(())
                    })
                )
            ]
        )
    }
    
}

// MARK: - Add necessary data for SKUIfy cell

extension COGSettingsViewModel {
    
    private func addSKUIfyDataToStorages(_ input: COGSettingsInputModel) {
        var input = input
        getEditGOGData(
            FulfilmentType(rawValue: input.fulfilment)
                .cogsSettingsRawValue
        )
            .withUnretained(self)
            .map { owner, cogsSettingsModel in
                input.skuifyItemData = cogsSettingsModel.toCOGSettingsItem()
                return (owner, input)
            }
            .do(onNext: { owner, data in
                owner.visibleDataStorage.onNext(data)
                owner.changedDataStorage.onNext(data)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: Subscribtions

extension COGSettingsViewModel {
    
    private func subscribtions() {
        subscribeOnUnitCostEditing()
        subscribeOnQuantityEditing()
        subscribeOnPurchasedFromEditing()
        subscribeOnBundledState()
        subscribeOnBBPImportStrategyState()
        subscribeOnApplyToUnsoldInventoryState()
        subscribeOnTapOnRecalculate()
        subscrubeOnTapOnSave()
    }
    
    private func subscribeOnUnitCostEditing() {
        unitCostEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { unitCost, storage in
                return (unitCost, storage)
            }
            .map { unitCost, storage in
                var storage = storage
                storage.unitCost = Double(unitCost)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnQuantityEditing() {
        quantityEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { quantity, storage in
                return (quantity, storage)
            }
            .map { quantity, storage in
                var storage = storage
                storage.quantity = quantity
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnPurchasedFromEditing() {
        purchasedFromEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { purchasedFrom, storage in
                return (purchasedFrom, storage)
            }
            .map { purchasedFrom, storage in
                var storage = storage
                storage.purchasedFrom = purchasedFrom
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnBundledState() {
        bundledStateChenged
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { bundled, storage in
                return (bundled, storage)
            }
            .map { bundled, storage in
                var storage = storage
                storage.bundled = bundled
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnBBPImportStrategyState() {
        cangedBBPImportStrategy
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { strategy, dataStorage in
                (strategy, dataStorage)
            }
            .map { strategy, dataStorage in
                var dataStorage = dataStorage
                dataStorage.bbpImportStrategy = dataStorage.bbpImportStrategy == strategy ? .none : strategy
                return dataStorage
            }
            .withUnretained(self)
            .do(onNext: { owner, dataStorage in
                owner.changedDataStorage.onNext(dataStorage)
            })
            .do(onNext: { owner, dataStorage in
                owner.visibleDataStorage.onNext(dataStorage)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnApplyToUnsoldInventoryState() {
        changedApplyToUnsoldInventory
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { applyToUnsoldInventory, storage in
                return (applyToUnsoldInventory, storage)
            }
            .map { applyToUnsoldInventory, storage in
                var storage = storage
                storage.applyToUnsoldInventory = applyToUnsoldInventory
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnTapOnRecalculate() {
        tapOnRecalculate
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete())
            .drive(visibleDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscrubeOnTapOnSave() {
        tapOnSave.asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete())
            .flatMapLatest(weak: self) { owner, changedDataStorage in
                Observable.combineLatest(
                    owner.updateGOGSettings(changedDataStorage.toCOGSettingsRequestModel()),
                    owner.updateBBGImportStategy(changedDataStorage.toImportStrategyRequestModel())
                     
                )
                .do(onNext: { _, _   in
                    print("all")
                })
                .trackActivity(owner.activityIndicator)
                .trackError(owner.errorTracker)
                .asDriverOnErrorJustComplete()
            }
            .withUnretained(self)
            .do { owner, _  in
                owner.navigator.toBack()
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Subscribtions on Input

extension COGSettingsViewModel {
    
    private func subscribeOnSelectedCalendarDate(_ input: Input) {
        input.selectedCalendarDate
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { date, changedDataStorage in
                return (date, changedDataStorage)
            }
            .map({ date, changedDataStorage in
                var changedDataStorage = changedDataStorage
                changedDataStorage.purchaseDate = date
                return changedDataStorage
            })
            .withUnretained(self)
            .do(onNext: { owner, changedDataStorage in
                owner.changedDataStorage.onNext(changedDataStorage)
            })
            .map { $1 }
            .drive(visibleDataStorage)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Requests

extension COGSettingsViewModel {
    
    private func getEditGOGData(_ settingsType: String) -> Driver<CostOfGoodsSettingsModel> {
        cogsInformationUseCase
            .getCOGSInformation(settingsType)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
    }
    
    private func updateBBGImportStategy(_ data: BbpImoprtStategyRequestModel) -> Observable<Void> {
        bbgImportStategyUseCase
            .updateBBPImportStrategy(data)
    }
    
    private func updateGOGSettings(_ data: COGSettingsRequestModel) -> Observable<Void> {
        cogSettingsUseCase
            .updateProductSettings(data)
    }
    
}


