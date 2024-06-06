//
//  COGViewModel.swift
//  SKUify
//
//  Created by George Churikov on 29.03.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class COGViewModel: COGBaseViewModel {
    private let disposeBag = DisposeBag()
    
    // Subscribers
    
    private let unitCostEditing = PublishSubject<String>()
    private let quantityEditing = PublishSubject<Int?>()
    private let purchasedFromEditing = PublishSubject<String>()
    private let bundledStateChenged = PublishSubject<Bool>()
    
    private let bundlingEditing = PublishSubject<String>()
    private let prepFeeEditing = PublishSubject<String>()
    private let packagingEditing = PublishSubject<String>()
    private let handlingEditing = PublishSubject<String>()
    private let otherEditing = PublishSubject<String>()
    private let shippingEditing = PublishSubject<String>()
    private let inboundShippingEditing = PublishSubject<String>()
    private let extraFeeEditing = PublishSubject<String>()
    private let extraFeePercEditing = PublishSubject<String>()
    
    private let tapOnClear = PublishSubject<Void>()
    private let tapOnUndo = PublishSubject<Void>()
    private let tapOnRecalculate = PublishSubject<Void>()
    
    private let tapOnDelete = PublishSubject<Void>()
    private let tapOnSaveOrUpdate = PublishSubject<Void>()
    
    private let showCalendarPopover = PublishSubject<CGPoint>()
        
    // Can be change only for ui update
    private let visibleDataStorage: BehaviorSubject<COGInputModel>
    // Changed data
    private let changedDataStorage: BehaviorSubject<COGInputModel>
    // Use when tap on undo(bind to visibleDataStorage)
    private let unchangedDataStorage: BehaviorSubject<COGInputModel>
    
    // Dependencies
    private let navigator: COGNavigatorProtocol
    
    // Use case storage
    private let breakEvenPointUseCase: Domain.BreakEvenPointUseCase
    private let cogUseCase: Domain.COGUseCase
    private let replenishCogUseCase: Domain.ReplenishCOGUseCase
    private let keyboardUseCase: Domain.KeyboardUseCase

    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        input: COGInputModel,
        useCases: COGUseCases,
        navigator: COGNavigatorProtocol
    ) {
        self.breakEvenPointUseCase = useCases.makeBreakEvenPointUseCase()
        self.cogUseCase = useCases.makeCOGUseCase()
        self.replenishCogUseCase = useCases.makeReplenishCOGUseCase()
        self.keyboardUseCase = useCases.makeKeyboardUseCase()
        
        self.visibleDataStorage = .init(value: input)
        self.unchangedDataStorage = .init(value: input)
        self.changedDataStorage = .init(value: input)
        
        self.navigator = navigator
        super.init()

        subscribtions()
    }
    
    override func transform(_ input: Input) -> Output {
        _ = super.transform(input)
        subscribeOnSelectedCalendarDate(input)
        
        return Output(
            title: makeTitle(),
            collectionData: makeCollectionData(),
            showCalendarPopover: showCalendarPopover.asDriverOnErrorJustComplete(),
            keyboardHeight: getKeyboardHeight(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error)
        )
    }
    
    private func makeTitle() -> Driver<String> {
        .just("COG")
    }
    
    // MARK: Make collection data
    
    private func makeCollectionData() -> Driver<[COGSectionModel]> {
        visibleDataStorage
            .asDriverOnErrorJustComplete()
            .map(self) { owner, data in
                return owner.makeCollectionData(data)
            }
    }
    
    private func makeCollectionData(_ data: COGInputModel) -> [COGSectionModel] {
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
                model: .defaultSection(),
                items: [
                    .costOfGoods(
                        makeCostOfGoodsCellInput(data)
                    )
                ]
            ),
            .init(
                model: .defaultSection(),
                items: [.costSummary(makeCostSummaryCellInput(data))]
            )
        ]
    }
    
    private func makeMainCellInput(_ data: COGInputModel) -> COGMainCell.Input {
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
    
    private func makePurchaseDetailCellInput(_ data: COGInputModel) -> COGPurchaseDetailCell.Input {
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
                                },
                                lockInput: isCanChangeQuantity(data)
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
                                },
                                lockInput: isCanChangePurchasedFrom(data)
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
    
    private func makeCostOfGoodsCellInput(_ data: COGInputModel) -> COGCostOfGoodsCell.Input {
        .init(
            title: "Cost of Goods Information",
            content: [
                makeBundleFeeViewType(data),
                .titledView(
                    .init(
                        title: "Prep Fee",
                        viewType: .textField(
                            .init(
                                style: .doubleBordered(data.currencySymbol),
                                text: data.prepFee.toUnwrappedString(),
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.prepFeeEditing.onNext(text)
                                }
                            )
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Packaging",
                        viewType: .textField(
                            .init(
                                style: .doubleBordered(data.currencySymbol),
                                text: data.packaging.toUnwrappedString(),
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.packagingEditing.onNext(text)
                                }
                            )
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Handling",
                        viewType: .textField(
                            .init(
                                style: .doubleBordered(data.currencySymbol),
                                text: data.handling.toUnwrappedString(),
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.handlingEditing.onNext(text)
                                }
                            )
                            
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Other",
                        viewType: .textField(
                            .init(
                                style: .doubleBordered(data.currencySymbol),
                                text: data.other.toUnwrappedString(),
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.otherEditing.onNext(text)
                                }
                            )
                            
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Shipping",
                        viewType: .textField(
                            .init(
                                style: .doubleBordered(data.currencySymbol),
                                text: data.shipping.toUnwrappedString(),
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.shippingEditing.onNext(text)
                                }
                            )
                            
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Inbound Shipping Cost (LB)",
                        viewType: .textField(
                            .init(
                                style: .doubleBordered(data.currencySymbol),
                                text: data.inboundShipping.toUnwrappedString(),
                                textObserver: { [weak self] text in
                                     guard let self else { return }
                                    self.inboundShippingEditing.onNext(text)
                                }
                            )
                            
                        )
                    )
                ),
                .titledViewsInLine(
                    [
                        .init(
                            title: "Extra Fee",
                            viewType: .textField(
                                .init(
                                    style: .doubleBordered(data.currencySymbol),
                                    text: data.extraFee.toUnwrappedString(),
                                    textObserver: { [weak self] text in
                                        guard let self else { return }
                                        self.extraFeeEditing.onNext(text)
                                    }
                                )
                                
                            )
                        ),
                        .init(
                            title: "OR",
                            viewType: .textField(
                                .init(
                                    style: .doubleBordered("%"),
                                    text: data.extraFeePerc.toUnwrappedString(),
                                    textObserver: { [weak self] text in
                                        guard let self else { return }
                                        self.extraFeePercEditing.onNext(text)
                                    }
                                )
                                
                            )
                        )
                    ]
                ),
                .buttons(
                    [
                        .init(
                            title: "Undo",
                            style: .primary,
                            action: .simple({ [weak self] in
                                guard let self else { return }
                                self.tapOnUndo.onNext(())
                            })
                        ),
                        .init(
                            title: "Clear",
                            style: .primary,
                            action: .simple({ [weak self] in
                                guard let self else { return }
                                self.tapOnClear.onNext(())
                            })
                        ),
                        .init(
                            title: "Recalculate",
                            style: .primary,
                            action: .simple({ [weak self] in
                                guard let self else { return }
                                self.tapOnRecalculate.onNext(())
                            })
                        )
                    ]
                )
            ]
        )
    }
    
    private func makeCostSummaryCellInput(_ data: COGInputModel) -> COGCostSummaryCell.Input {
        .init(
            content: [
                .label("Total Cost of Goods £ \(data.calculateTotalCost().toString())"),
                makeBreakEvenPointViewType(data),
                .buttons(
                    [
                        .init(
                            title: "Delete",
                            style: .primary,
                            action: .simple(makeDeleteAction(data))
                        ),
                        .init(
                            title: data.cogType == .newReplenish ? "Save" : "Update",
                            style: .primary,
                            action: .simple({ [weak self] in
                                guard let self else { return }
                                self.tapOnSaveOrUpdate.onNext(())
                            })
                        )
                    ]
                )
            ]
        )
    }
    
    private func makeBundleFeeViewType(_ data: COGInputModel) -> COGCOfGViewType {
        data.bundled ? .titledView(
            .init(
                title: "Bundled Fee",
                viewType: .textField(
                    .init(
                        style: .doubleBordered(data.currencySymbol),
                        text: data.bundling.toUnwrappedString(),
                        textObserver: { [weak self] text in
                            guard let self else { return }
                            self.bundlingEditing.onNext(text)
                        }
                    )
                )
            )
        ) : .none
    }
    
   
    
}

// MARK: - Helper methods

extension COGViewModel {
    
    private func makeBreakEvenPointViewType(_ data: COGInputModel) -> COGCostSummaryViewType {
        guard let breakEvenPoint = data.breakEvenPoint, breakEvenPoint != 0.00 else { return .none }
        return .label("Break even point £ \(data.breakEvenPoint.toUnwrappedString())")
    }
    
    private func makeDeleteAction(_ data: COGInputModel) -> (() -> Void)? {
        data.cogType == .newReplenish ? { [weak self] in
            
        } : nil
    }
    
    private func isCanChangeQuantity(_ data: COGInputModel) -> Bool {
        !(data.cogType == .newReplenish)
    }
    
    private func isCanChangePurchasedFrom(_ data: COGInputModel) -> Bool {
        !(data.cogType == .newReplenish ||
          data.cogType == .inventory)
    }
    
    
}

// MARK: - Subscribtions

extension COGViewModel {
    
    private func subscribtions() {
        subscribeOnUnitCostEditing()
        subscribeOnQuantityEditing()
        subscribeOnPurchasedFromEditing()
        subscribeOnBundledState()
        subscribeOnBundlingEditing()
        subscribeOnPrepFeeEditing()
        subscribeOnPackagingEditing()
        subscribeOnHandlingEditing()
        subscribeOnOtherEditing()
        subscribeOnShippingEditing()
        subscribeOnInboundShippingEditing()
        subscribeOnExtraFeeEditing()
        subscribeOnExtraFeePercEditing()
        subscribeOnTapOnClear()
        subscribeOnTapOnUndo()
        subscribeOnTapOnRecalculate()
        subscribeOnTapOnUpdate()
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
        // save to changedDataStorage
            .do(self) { owner, data in
                owner.changedDataStorage.onNext(data)
            }
            .drive(visibleDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnBundlingEditing() {
        bundlingEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { bundling, storage in
                return (bundling, storage)
            }
            .map { bundling, storage in
                var storage = storage
                storage.bundling = Double(bundling)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnPrepFeeEditing() {
        prepFeeEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { prepFee, storage in
                return (prepFee, storage)
            }
            .map { prepFee, storage in
                var storage = storage
                storage.prepFee = Double(prepFee)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnPackagingEditing() {
        packagingEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { packaging, storage in
                return (packaging, storage)
            }
            .map { packaging, storage in
                var storage = storage
                storage.packaging = Double(packaging)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnHandlingEditing() {
        handlingEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { handling, storage in
                return (handling, storage)
            }
            .map { handling, storage in
                var storage = storage
                storage.handling = Double(handling)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnOtherEditing() {
        otherEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { other, storage in
                return (other, storage)
            }
            .map { other, storage in
                var storage = storage
                storage.other = Double(other)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnShippingEditing() {
        shippingEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { shipping, storage in
                return (shipping, storage)
            }
            .map { shipping, storage in
                var storage = storage
                storage.shipping = Double(shipping)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnInboundShippingEditing() {
        inboundShippingEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { inboundShipping, storage in
                return (inboundShipping, storage)
            }
            .map { inboundShipping, storage in
                var storage = storage
                storage.inboundShipping = Double(inboundShipping)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnExtraFeeEditing() {
        extraFeeEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { extraFee, storage in
                return (extraFee, storage)
            }
            .map { extraFee, storage in
                var storage = storage
                storage.extraFee = Double(extraFee)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnExtraFeePercEditing() {
        extraFeePercEditing
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete()) { extraFeePerc, storage in
                return (extraFeePerc, storage)
            }
            .map { extraFeePerc, storage in
                var storage = storage
                storage.extraFeePerc = Double(extraFeePerc)
                return storage
            }
            .drive(changedDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnTapOnClear() {
        tapOnClear
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete())
            .map { $0.clearCostOfGoods() }
        // Recalculate break even point
            .flatMapLatest(
                weak: self,
                selector: { owner, unchangedData in
                    return owner.getBreakEvenPoint(unchangedData)
                        .map { breakEvenData in
                            var unchangedData = unchangedData
                            unchangedData.breakEvenPoint = breakEvenData.breakPointEven
                            return unchangedData
                        }
                })
        // save to changedDataStorage
            .do(self) { owner, data in
                owner.changedDataStorage.onNext(data)
            }
            .drive(visibleDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnTapOnUndo() {
        tapOnUndo
            .asDriverOnErrorJustComplete()
            .withLatestFrom(unchangedDataStorage.asDriverOnErrorJustComplete())
        // Recalculate break even point
            .flatMapLatest(
                weak: self,
                selector: { owner, unchangedData in
                    return owner.getBreakEvenPoint(unchangedData)
                        .map { breakEvenData in
                            var unchangedData = unchangedData
                            unchangedData.breakEvenPoint = breakEvenData.breakPointEven
                            return unchangedData
                        }
                })
        // save to changedDataStorage
            .do(self) { owner, data in
                owner.changedDataStorage.onNext(data)
            }
            .drive(visibleDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnTapOnRecalculate() {
        tapOnRecalculate
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete())
            .flatMapFirst(weak: self) { owner, data in
                owner.getBreakEvenPoint(data)
                    .asDriverOnErrorJustComplete()
                    .map { $0.breakPointEven }
                    .map { breakPointEven in
                        var data = data
                        data.breakEvenPoint = breakPointEven
                        return data
                    }
            }
        // save to changedDataStorage
            .do(self) { owner, data in
                owner.changedDataStorage.onNext(data)
            }
            .drive(visibleDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnTapOnUpdate() {
        tapOnSaveOrUpdate
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedDataStorage.asDriverOnErrorJustComplete())
            .flatMapLatest(weak: self) { owner, data in
                owner.updateOrSaveCOG(data)
                    .trackActivity(owner.activityIndicator)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .drive(with: self) { owner, _ in
                owner.navigator.toBack()
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Subscribtions on Input

extension COGViewModel {
    
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
            .do(self) { owner, changedDataStorage in
                owner.changedDataStorage.onNext(changedDataStorage)
            }
            .drive(visibleDataStorage)
            .disposed(by: disposeBag)
    }
    
}

// MARK: Get keyboard height

extension COGViewModel {

    private func getKeyboardHeight() -> Driver<CGFloat> {
        keyboardUseCase
            .getKeyboardHeight()
            .asDriverOnErrorJustComplete()
    }
    
}

// MARK: - Requests

extension COGViewModel {
    
    func getBreakEvenPoint(_ data: COGInputModel) -> Observable<BreakEvenPointDTO> {
        switch data.cogType {
        case .sales:
            return breakEvenPointUseCase
                .getSalesBreakEvenPoint(data.toBreakEvenRequestModel())
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
        case .inventory,
                .newReplenish:
            return breakEvenPointUseCase
                .getInventoryBreakEvenPoint(data.toBreakEvenRequestModel())
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
        }
    }

    func updateOrSaveCOG(_ data: COGInputModel) -> Observable<Void> {
        switch data.cogType {
        case .sales:
            return cogUseCase
                .updateSalesCOG(data.toSalesRequestModel())
        case .inventory:
            return cogUseCase
                .updateInventoryCOG(data.toInventoryRequestModel())
        case .newReplenish:
            guard data.quantity != nil else {
                return .error(CustomError(message: "Quintity is required"))
            }
            return replenishCogUseCase
                .saveReplenish(data.toReplenishRequestModel())
        }
    }
    
}
