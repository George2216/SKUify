//
//  NewExpenseViewModel.swift
//  SKUify
//
//  Created by George Churikov on 23.05.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class NewExpenseViewModel: BaseExpensesViewModel {
    private let disposeBag = DisposeBag()
    
    private let collectionDataStorage = BehaviorSubject<[ExpensesSectionModel]>(value: [])

    private let visibleExpensesDataStorage = BehaviorSubject<[ExpenseDTO]>(value: [ExpenseDTO.base()])
    private let changedExpensesDataStorage = BehaviorSubject<[ExpenseDTO]>(value: [ExpenseDTO.base()])

    // Dependencies
    private let navigator: NewExpenseNavigatorProtocol
    
    // Use case storage
    private let expensesCategoriesUseCase: Domain.ExpensesCategoriesReadDataUseCase

    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: NewExpenseUseCases,
        navigator: NewExpenseNavigatorProtocol
    ) {
        self.navigator = navigator
        self.expensesCategoriesUseCase = useCases.makeExpensesCategoriesDataUseCase()
        super.init()
        
        makeExpensesCollectionData()
    }
    
    override func transform(_ input: Input) -> Output {
        _ = super.transform(input)
        subscribeOnReloadData(input)
        return .init(
            title: makeTitle(),
            collectionData: collectionDataStorage.asDriverOnErrorJustComplete(),
            showCalendarPopover: .empty(),
            showSimpleTablePopover: .empty(),
            isShowPaginatedLoader: .empty(),
            rightBarButtonConfig: makeAddButtonConfig(),
            leftBarButtonConfig: makeCancelButtonConfig(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error)
        )
    }
    
    private func makeTitle() -> Driver<String> {
        return .just("Create new expense")
    }
    
}

// MARK: - Make collection data

extension NewExpenseViewModel {
    
    private func prepareDataForCollection() -> Driver<([ExpenseDTO], [ExpensesCategoryDTO])> {
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
    }
    
    private func makeExpensesCollectionData() {
        prepareDataForCollection()
            .withUnretained(self)
            .map { (owner, arg1) in
                let (expenses, categories) = arg1
                return expenses.map { expense in
                        return .init(
                            model: .defaultSection(
                                header: "",
                                footer: ""
                            ),
                            items: [
                                .expenses(
                                    owner.makeEpensionCellInput(
                                        expense: expense,
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
    
    private func makeEpensionCellInput(
        expense: ExpenseDTO,
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
                                textObserver: { _ in
                                    
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
                                            textObserver: { _ in
                                                
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
                                            switchChanged: { _ in
                                                
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
                                            textObserver: { _ in
                                                
                                            },
                                            lockInput: !expense.isOnVat
                                        )
                                    )
                                )
                            )
                        ]
                    )
            ]
        )
    }
    
}

// MARK: - Make buttons configs

extension NewExpenseViewModel {
    
    private func makeCancelButtonConfig() -> Driver<DefaultBarButtonItem.Config> {
        .just(
            .init(
                style: .textable("Cancel"),
                actionType: .base({ [weak self] in
                    guard let self else { return }
                    self.navigator.toBack()
                })
            )
        )
    }
    
    private func makeAddButtonConfig() -> Driver<DefaultBarButtonItem.Config> {
        .just(
            .init(
                style: .textable("Add"),
                actionType: .base({ [weak self] in
                    guard let self else { return }
//                    self.navigator.toNewExpense()
                })
            )
        )
    }
    
}

// MARK: Subscribers from Input

extension NewExpenseViewModel {
    
    private func subscribeOnReloadData(_ input: Input) {
        input.reloadData
            .withUnretained(self)
            .drive(onNext: { owner, _ in
                owner.activityIndicator.stopTracker()
            })
            .disposed(by: disposeBag)
    }
    
}
