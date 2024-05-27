//
//  ExpensesViewModel.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

enum ExpensesType {
    case allExpenses
    case newExpense
}

final class ExpensesViewModel: ViewModelProtocol {
    private let disposeBag = DisposeBag()
        
    private let updateExpense = PublishSubject<ExpenseUpdateModel>()
    
    // MARK: - Storages
        
    private let collectionDataStorage = BehaviorSubject<[ExpensesSectionModel]>(value: [])
    
    private let paginatedData = BehaviorSubject<ExpensesPaginatedModel>(value: .base())
    private let paginationCounter = BehaviorSubject<Int?>(value: nil)
    private let isShowPaginatedLoader = PublishSubject<Bool>()

    private let visibleExpensesDataStorage = BehaviorSubject<[ExpenseDTO]>(value: [])
    private let changedExpensesDataStorage = BehaviorSubject<[ExpenseDTO]>(value: [])
    
    private let tapOnSaveExpense = PublishSubject<Void>()

    // Popovers
    private let showCalendarPopover = PublishSubject<PopoverGroupedModel<Date, Any>>()
    private let showSimpleTablePopover = PublishSubject<PopoverGroupedModel<Int, String>>()
    
    // Dependencies
    private let navigator: ExpensesNavigatorProtocol
    
    private let expensesType: BehaviorSubject<ExpensesType>

    // Use case storage
    private let expensesUseCase: Domain.ExpensesUseCase
    private let expensesCategoriesUseCase: Domain.ExpensesCategoriesReadDataUseCase

    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: ExpensesUseCases,
        navigator: ExpensesNavigatorProtocol,
        expensesType: ExpensesType
    ) {
        self.expensesType = .init(value: expensesType)
        
        self.navigator = navigator
        self.expensesUseCase = useCases.makeExpensesUseCase()
        self.expensesCategoriesUseCase = useCases.makeExpensesCategoriesDataUseCase()
        
        makeExpensesCollectionData()
    }
    
     func transform(_ input: Input) -> Output {
        subscribtions()

        subscribeOnReloadData(input)
        subscribeOnScreenDisappear(input)
        subscribeOnVisibleSection(input)
        return Output(
            title: makeTitle(),
            collectionData: collectionDataStorage.asDriverOnErrorJustComplete(),
            showCalendarPopover: showCalendarPopover.asDriverOnErrorJustComplete(),
            showSimpleTablePopover: showSimpleTablePopover.asDriverOnErrorJustComplete(), 
            isShowPaginatedLoader: isShowPaginatedLoader.asDriverOnErrorJustComplete(),
            rightBarButtonConfig: makeRightBarButtonConfig(),
            leftBarButtonConfig: makeLeftBarButtonConfig(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error)
        )
    }
    
    private func reloadData() {
        // Clear storages
        visibleExpensesDataStorage.onNext([])
        changedExpensesDataStorage.onNext([])
        // Reload data
        paginationCounter.onNext(0)
    }
    
    private func makeTitle() -> Driver<String> {
        expensesType
            .map { expensesType in
                switch expensesType {
                case .allExpenses:
                    return "Expenses"
                case .newExpense:
                    return "Add new expense"
                }
            }
            .asDriverOnErrorJustComplete()
    }
    
}

// MARK: - Make collection data

extension ExpensesViewModel {
    
    private func prepareDataForCollection() -> Driver<([ExpenseDTO], [ExpensesCategoryDTO], ExpensesType)> {
        visibleExpensesDataStorage
            .asDriverOnErrorJustComplete()
            .flatMapLatest(weak: self) { owner, expenses in
                owner.expensesCategoriesUseCase
                    .getCategories()
                    .asDriverOnErrorJustComplete()
                    .map { categories in
                        return (expenses, categories)
                    }
            }
            .withLatestFrom(expensesType.asDriverOnErrorJustComplete()) { (arg0, expensesType) in
                let (expenses, categories) = arg0
                return (expenses, categories, expensesType)
            }
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                self.isShowPaginatedLoader.onNext(false)
            })
    }
    
    private func makeExpensesCollectionData() {
        prepareDataForCollection()
            .withUnretained(self)
            .map { (owner, arg1) in
                let (expenses, categories, expensesType) = arg1
                return expenses.enumerated()
                    .map { index, expense in
                        return .init(
                            model: .defaultSection(
                                header: owner.makeCollectionHeader(
                                    section: index,
                                    expensesType: expensesType
                                ),
                                footer: ""
                            ),
                            items: [
                                .expenses(
                                    owner.makeEpensionCellInput(
                                        expense: expense,
                                        expensesType: expensesType,
                                        categories: categories
                                    )
                                )
                            ]
                        )
                    }
            }
            .drive(collectionDataStorage)
            .disposed(by: disposeBag)
    }
    
    private func makeCollectionHeader(
        section: Int,
        expensesType: ExpensesType
    ) -> String {
        if section == 0 && expensesType == .allExpenses {
            return "You can use this area to record expenses that need to be factored into your financial figures for example, sourcing services, sourcing software, deal analysis tools etc."
        }
        return ""
    }
    
    private func makeEpensionCellInput(
        expense: ExpenseDTO,
        expensesType: ExpensesType,
        categories: [ExpensesCategoryDTO]
    ) -> ExpensesCell.Input {
        return .init(
            content: [
                .titledView(
                    .init(
                        title: "Name",
                        viewType: .textField(
                            .init(
                                style: .bordered,
                                text: expense.name,
                                textObserver: makeUpdateExpenseClosure(for: expense.id) { expense, text in
                                    expense.name = text
                                }
                            )
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Category",
                        viewType: .button(
                            .init(
                                title: categories
                                    .filter({ $0.id == expense.categoryId })
                                    .first?
                                    .name ?? "-",
                                style: .popover,
                                action: .point({ [weak self] center in
                                    guard let self else { return }
                                    self.showSimpleTablePopover.onNext(
                                        .init(
                                            center: center,
                                            input: .init(
                                                content: categories.map { $0.name } ,
                                                startValue: categories.map { $0.id }
                                                    .firstIndex(of: expense.categoryId),
                                                observer: self.makeUpdateExpenseClosure(
                                                    for: expense.id,
                                                    isUpdateUI: true
                                                ) { expense, index in
                                                    expense.categoryId = categories[index].id
                                                }
                                            )
                                        )
                                    )
                                })
                            )
                        )
                    )
                ),
                .titledView(
                    .init(
                        title: "Method",
                        viewType: .button(
                            .init(
                                    title: CalculationMethod(rawValue: expense.method)
                                        .title,
                                    style: .popover,
                                    action: .point({ [weak self] center in
                                        guard let self else { return }
                                        self.showSimpleTablePopover.onNext(
                                            .init(
                                                center: center,
                                                input: .init(
                                                    content: CalculationMethod.allCases
                                                        .map { $0.title } ,
                                                    startValue: CalculationMethod(rawValue: expense.method).index,
                                                    observer: self.makeUpdateExpenseClosure(
                                                        for: expense.id,
                                                        isUpdateUI: true
                                                    ) { expense, index in
                                                        expense.method = CalculationMethod(index: index)
                                                            .key
                                                    }
                                                )
                                            )
                                        )
                                    })
                                )
                            )
                        )
                    ),
                    .titledView(
                        .init(
                            title: "Frequency",
                            viewType: .button(
                                .init(
                                    title: PeriodType(rawValue: expense.interval)
                                        .title,
                                    style: .popover,
                                    action: .point({ [weak self] center in
                                        guard let self else { return }
                                        self.showSimpleTablePopover.onNext(
                                            .init(
                                                center: center,
                                                input: .init(
                                                    content: PeriodType.allCases
                                                        .map { $0.title } ,
                                                    startValue: PeriodType(rawValue: expense.interval).index,
                                                    observer: self.makeUpdateExpenseClosure(
                                                        for: expense.id,
                                                        isUpdateUI: true
                                                    ) { expense, index in
                                                        expense.interval = PeriodType(index: index).key
                                                    }
                                                )
                                            )
                                        )
                                    })
                                )
                            )
                        )
                    ),
                    .horizontalViews(
                        [
                            .titledView(
                                .init(
                                    title: "Start Date",
                                    viewType: .button(
                                        .init(
                                            title: expense.startDate
                                                .toDate()?
                                                .ddMMyyyyString("/") ?? "-",
                                            style: .calendarPopover,
                                            action: .point({ [weak self] center in
                                                guard let self else { return }
                                                self.showCalendarPopover.onNext(
                                                    .init(
                                                        center: center,
                                                        input: .init(
                                                            startValue: expense.startDate.toDate(),
                                                            observer: self.makeUpdateExpenseClosure(
                                                                for: expense.id,
                                                                isUpdateUI: true
                                                            ) { expense, date in
                                                                expense.startDate = date.ddMMyyyyString("/")
                                                            }
                                                        )
                                                    )
                                                )
                                            })
                                        )
                                    )
                                )
                            ),
                            .titledView(
                                .init(
                                    title: "End Date",
                                    viewType: .button(
                                        .init(
                                            title: expense.endDate?
                                                .toDate()?
                                                .ddMMyyyyString("/") ?? "-",
                                            style: .calendarPopover,
                                            action: .point({ [weak self] center in
                                                guard let self else { return }
                                                self.showCalendarPopover.onNext(
                                                    .init(
                                                        center: center,
                                                        input: .init(
                                                            startValue: expense.endDate?.toDate(),
                                                            observer: self.makeUpdateExpenseClosure(
                                                                for: expense.id,
                                                                isUpdateUI: true
                                                            ) { expense, date in
                                                                expense.endDate = date.ddMMyyyyString("/")
                                                            }
                                                        )
                                                    )
                                                )
                                            })
                                        )
                                    )
                                )
                            )
                    ]
                    ),
                    .horizontalViews(
                        [
                            .titledView(
                                .init(
                                    title: "Amount ($)",
                                    viewType: .textField(
                                        .init(
                                            style: .doubleBordered("$"),
                                            text: expense.amount
                                                .toString(),
                                            textObserver: makeUpdateExpenseClosure(for: expense.id) { expense, text in
                                                expense.amount = Double(text) ?? 0.0
                                            }
                                        )
                                    )
                                )
                            ),
                            .titledView(
                                .init(
                                    title: "VAT",
                                    viewType: .smallSwitch(
                                        .init(
                                            state: expense.isOnVat,
                                            switchChanged: makeUpdateExpenseClosure(
                                                for: expense.id,
                                                isUpdateUI: true
                                            ) { expense, isOn in
                                                expense.isOnVat = isOn
                                            }
                                        )
                                    )
                                )
                            ),
                            .titledView(
                                .init(
                                    title: "VAT %",
                                    viewType: .textField(
                                        .init(
                                            style: .doubleBordered("%"),
                                            text: expense.isOnVat ? expense.vat.toString() : "",
                                            textObserver: makeUpdateExpenseClosure(for: expense.id) { expense, text in
                                                expense.vat = Double(text) ?? 0.0
                                            },
                                            lockInput: !expense.isOnVat
                                        )
                                    )
                                )
                            )
                        ]
                    ),
                makeBottomButtonsConfigs(
                    expense: expense,
                    expensesType: expensesType
                )
            ]
        )
    }
    
    private func makeBottomButtonsConfigs(
        expense: ExpenseDTO,
        expensesType: ExpensesType
    ) -> ExpensesCell.ViewType {
        switch expensesType {
        case .newExpense:
            return .none
        case .allExpenses:
            return .smallButtons(
                [
                    .init(
                        title: "",
                        style: .image(.more),
                        action: .simple({ [weak self] in
                            guard let self else { return }
                            self.navigator.toTransactions()
                            
                        })
                    ),
                    .init(
                        title: "",
                        style: .image(.deleteLight),
                        action: .simple({
                            
                        })
                    )
                ]
            )
        }
    }
    
}

// MARK: - Hepler methods

extension ExpensesViewModel {
    
    private func makeUpdateExpenseClosure<T>(
        for id: String,
        isUpdateUI: Bool = false,
        _ update: @escaping (inout ExpenseDTO, T) -> Void
    ) -> (T) -> Void {
        return { [weak self] value in
            guard let self = self else { return }
            self.updateExpense.onNext(
                .init(
                    id: id,
                    isUpdateUI: isUpdateUI,
                    item: { expense in
                        var expense = expense
                        update(&expense, value)
                        return expense
                    }
                )
            )
        }
    }
    
}

// MARK: - Make buttons configs

extension ExpensesViewModel {
    
    private func makeLeftBarButtonConfig() -> Driver<DefaultBarButtonItem.Config> {
        expensesType
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .map { owner, expenseType in
                switch expenseType {
                case .allExpenses:
                    return owner.makeAddExpenseButtonConfig()
                case .newExpense:
                    return owner.makeCancelNewExpenseButtonConfig()
                }
            }
    }
    
    private func makeRightBarButtonConfig() -> Driver<DefaultBarButtonItem.Config>{
        expensesType
            .asDriverOnErrorJustComplete()
            .withUnretained(self)
            .map { owner, expenseType in
                switch expenseType {
                case .allExpenses:
                    return owner.makeSaveButtonConfig()
                case .newExpense:
                    return owner.makeSaveNewExpenseButtonConfig()
                }
            }
    }
    
    private func makeSaveButtonConfig() -> DefaultBarButtonItem.Config {
            .init(
                style: .textable("Save"),
                actionType: .base({ [weak self] in
                    guard let self else { return }
                    self.tapOnSaveExpense.onNext(())
                })
            )
    }
    
    private func makeAddExpenseButtonConfig() -> DefaultBarButtonItem.Config {
            .init(
                style: .image(.plus),
                actionType: .base({ [weak self] in
                    guard let self else { return }
                    self.navigator.toNewExpense()
                })
            )
    }
    
    private func makeCancelNewExpenseButtonConfig() -> DefaultBarButtonItem.Config {
            .init(
                style: .textable("Cancel"),
                actionType: .base({ [weak self] in
                    guard let self else { return }
                    self.navigator.backToExpenses()
                })
            )
    }
    
    private func makeSaveNewExpenseButtonConfig() -> DefaultBarButtonItem.Config {
            .init(
                style: .textable("Add"),
                actionType: .base({ [weak self] in
                    guard let self else { return }
                    self.tapOnSaveExpense.onNext(())
                })
            )
    }
    
}

// MARK: - Subscribtions

extension ExpensesViewModel {
    
    private func subscribtions() {
        networkSubscribers()
        subscribeOnUpdateExpense()
    }
    
    private func subscribeOnUpdateExpense() {
        let updatedExpensesDriver = updateExpense.asDriverOnErrorJustComplete()
            .withLatestFrom(changedExpensesDataStorage.asDriverOnErrorJustComplete()) { changer, changedExpensesDataStorage in
                return (changer, changedExpensesDataStorage)
            }
            .map  { changer, changedExpensesDataStorage in
                let updatedExpenses = changedExpensesDataStorage.map { expense in
                    if expense.id == changer.id {
                       return changer.item(expense)
                    } else {
                        return expense
                    }
                }
                return (changer.isUpdateUI, updatedExpenses)
            }
        
        // Update storage data and ui data
        
        updatedExpensesDriver
            .filter { $0.0 }
            .map { $1 }
            .shareElement(changedExpensesDataStorage)
            .shareElement(visibleExpensesDataStorage)
            .drive()
            .disposed(by: disposeBag)
        
        // Update storage data without updating UI

        updatedExpensesDriver
            .filter { !$0.0 }
            .map { $1 }
            .drive(changedExpensesDataStorage)
            .disposed(by: disposeBag)
    }
    
}

// MARK: Subscribers from Input

extension ExpensesViewModel {
    
    // Set paginated counter
    private func subscribeOnVisibleSection(_ input: Input) {
        let visibleSectionDriver = input.visibleSection
            .withLatestFrom(Driver.combineLatest(expensesType.asDriverOnErrorJustComplete(), activityIndicator.asDriver())) { (visibleSection, arg1) in
                let (expensesType, isItLoading) = arg1
                return (visibleSection, isItLoading, expensesType)
            }
            .filter { _, _, expensesType in
                switch expensesType {
                case .allExpenses:
                    return true
                default:
                    return false
                }
            }
            .filter { _, isItLoading, _ in
                return !isItLoading
            }
            .map { visibleSection, _, _ in visibleSection }
        
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
                guard let paginationCounter else { return 8 }
                return paginationCounter + 8
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

extension ExpensesViewModel {
    
    private func networkSubscribers() {
        subscribeOnExpenses()
        subscribeOnExpensesSaved()
    }
    
    private func subscribeOnExpenses() {
        fetchExpenses()
            .withUnretained(self)
            .withLatestFrom(changedExpensesDataStorage.asDriverOnErrorJustComplete()) { (arg0, storage) in
                let (owner, dto) = arg0
                return (owner, dto, storage)
            }
        // Save data to storages
            .map { owner, expenses, storage in
                var storage = storage
                storage.append(contentsOf: expenses)
                return storage
            }
            .shareElement(changedExpensesDataStorage)
            .shareElement(visibleExpensesDataStorage)
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnExpensesSaved() {
        updateExpenses()
            .shareElement(changedExpensesDataStorage)
            .shareElement(visibleExpensesDataStorage)
            .withLatestFrom(expensesType.asDriverOnErrorJustComplete())
            .withUnretained(self)
            .do(onNext: { owner, expensesType in
                switch expensesType {
                case .newExpense:
                    owner.navigator.backToExpenses()
                default:
                    break
                }
            })
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: Requests

extension ExpensesViewModel {
    
    private func fetchExpenses() -> Driver<[ExpenseDTO]> {
        return paginationCounter
            .compactMap { $0 }
            .withLatestFrom(paginatedData) { paginationCounter, paginatedData in
                return (paginationCounter, paginatedData)
            }
            .map { paginationCounter, paginatedData in
                var paginatedData = paginatedData
                paginatedData.offset = paginationCounter
                return paginatedData
            }
            .asDriverOnErrorJustComplete()
            .shareElement(paginatedData)
            .withLatestFrom(expensesType.asDriverOnErrorJustComplete()) { ($0, $1) }
            .flatMapLatest(weak: self) { (owner, arg1) -> Driver<[ExpenseDTO]> in
                let (paginatedData, expensesType) = arg1
                switch expensesType {
                case .newExpense:
                    return Observable.just([ExpenseDTO.base()])
                    // Needed to hide the loader
                        .trackActivity(owner.activityIndicator)
                        .asDriverOnErrorJustComplete()
                case .allExpenses:
                    return owner.expensesUseCase
                        .getExpenses(paginatedData)
                        .trackActivity(owner.activityIndicator)
                        .trackError(owner.errorTracker)
                        .asDriverOnErrorJustComplete()
                }
            }
    }
    
    private func updateExpenses() -> Driver<[ExpenseDTO]> {
        tapOnSaveExpense
            .asDriverOnErrorJustComplete()
            .withLatestFrom(changedExpensesDataStorage.asDriverOnErrorJustComplete())
            .flatMapLatest(weak: self) { owner, expenses  in
                var observable = Observable<Void>.just(())
                if let error = expenses.compactMap({ $0.error() }).first {
                    observable = .error(error)
                }
                return observable
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .withLatestFrom(changedExpensesDataStorage.asDriverOnErrorJustComplete())
            .flatMapLatest(weak: self) { owner, expenses in
                owner.expensesUseCase
                    .updateExpenses(expenses)
                    .trackActivity(owner.activityIndicator)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
    }
    
}

// MARK: Helper models

extension ExpensesViewModel {
        
    struct ExpenseUpdateModel {
        var id: String
        // true when need update ui after changes
        var isUpdateUI: Bool = false
        var item: (ExpenseDTO) -> ExpenseDTO
    }
    
}

extension ExpensesViewModel {
    
    struct Input {
        // viewDidAppear or swipe
        let reloadData: Driver<Void>
        // viewDidDisappear
        let screenDisappear: Driver<Void>
        // currently visible collection section
        let visibleSection: Driver<Int>
    }
    
    struct Output {
        let title: Driver<String>
        // Collection data
        let collectionData: Driver<[ExpensesSectionModel]>
        // Popovers
        let showCalendarPopover: Driver<PopoverGroupedModel<Date, Any>>
        let showSimpleTablePopover: Driver<PopoverGroupedModel<Int, String>>
        // Bottom loader
        let isShowPaginatedLoader: Driver<Bool>
        // Buttons configs
        let rightBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        let leftBarButtonConfig: Driver<DefaultBarButtonItem.Config>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
    }
    
}


