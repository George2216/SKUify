//
//  NotificationsViewModel.swift
//  SKUify
//
//  Created by George Churikov on 07.06.2024.
//

import Foundation
import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class NotificationsViewModel: ViewModelProtocol {
    private let disposeBag = DisposeBag()

    private let paginatedData = BehaviorSubject<NotificationsPaginatedModel>(value: .base())

    private let isShowPaginatedLoader = PublishSubject<Bool>()
    
    private let paginationCounter = BehaviorSubject<Int?>(value: nil)

    // MARK: - Data storages
    
    // Collection data storage
    private let tableDataStorage = BehaviorSubject<[NotificationsSectionModel]>(value: [])
    
    // DTO data storages
    private let notificationsDataStorage = BehaviorSubject<[NotificationDTO]>(value: [])
    
    // Dependencies
    private let navigator: NotificationsNavigatorProtocol
    
    // Use case storage
    private let notificationsUseCase: Domain.NotificationsUseCase
    
    // Trackers
    private var activityTracker = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: NotificationsUseCases,
        navigator: NotificationsNavigatorProtocol
    ) {
        self.navigator = navigator
        notificationsUseCase = useCases.makeNotificationsUseCase()
        subscribeOnNotifications()
        makeTableData()
    }
    
    func transform(_ input: Input) -> Output {
        subscribeOnReloadData(input)
        subscribeOnReachedBottom(input)
        subscribeOnItemSelected(input)
        subscribeOnItemDeleted(input)
        return Output(
            tableData: tableDataStorage.asDriverOnErrorJustComplete(),
            isShowPaginatedLoader: isShowPaginatedLoader.asDriverOnErrorJustComplete(),
            clearAllButtonConfig: makeClearAllBarButtonConfig(),
            fetching: activityTracker.asDriver(),
            error: errorTracker.asBannerInput()
        )
    }
    
    private func reloadData() {
        // Clear storages
        notificationsDataStorage.onNext([])
        // Reload data
        paginationCounter.onNext(0)
    }
}

// MARK: - Make bar button items

extension NotificationsViewModel {
    
    private func makeClearAllBarButtonConfig() -> Driver<DefaultBarButtonItem.Config> {
        .just(
            .init(
                style: .textable("Clear all"),
                actionType: .base({ [weak self] in
                    
                })
            )
        )
    }
    
}

// MARK: - Make collection data

extension NotificationsViewModel {
    
    private func makeTableData() {
        makeNotificationsTableData()
            .do(self) { owner, _ in
                owner.isShowPaginatedLoader.onNext(false)
            }
            .drive(tableDataStorage)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Make Notifications collection data

extension NotificationsViewModel {
    
    private func makeNotificationsTableData() -> Driver<[NotificationsSectionModel]> {
        notificationsDataStorage
            .asDriverOnErrorJustComplete()
            .map(self) { owner,  notifications in
                let groupedNotifications = notifications.groupedByDay()
                
                return groupedNotifications
                    .sorted { $0.key > $1.key }
                    .map { date, notifications in
                        let items = notifications
                            .sorted(by: { $0.date.toDate() ?? Date() > $1.date.toDate() ?? Date()})
                            .map { notification -> NotificationsCollectionItem in
                        return .notification( owner.makeNotificationCellInput(notification))
                    }
                    return .init(
                        model: .defaultSection(header: date.ddMMMMyyyyString(" ")),
                        items: items
                    )
                }
                
            }
    }
    
    private func makeNotificationCellInput(_ notification: NotificationDTO) -> NotificationCell.Input {
        switch notification.notificationType {
        case .order(let orderData):
            return .init(
                id: notification.id,
                type: .sales,
                title: "\(notification.notificationSubtype) \(orderData.name)",
                highlightedTitleText: notification.notificationSubtype,
                subtitle: "\(orderData.asin), Price: \(orderData.amount)",
                eventType: orderData.eventType,
                date: notification.date.toDate()?.hmma() ?? ""
            )
        case .inventory(let inventoryData):
            return .init(
                id: notification.id,
                type: .inventory,
                title: "\(notification.notificationSubtype) \(inventoryData.name)",
                highlightedTitleText: notification.notificationSubtype,
                subtitle: inventoryData.asin,
                eventType: inventoryData.eventType,
                date: notification.date.toDate()?.hmma() ?? ""
            )
        case .none:
            return .init(
                id: notification.id,
                type: .sales,
                title: "Some Notification",
                highlightedTitleText: "",
                subtitle: "",
                eventType: "",
                date: notification.date.toDate()?.hmma() ?? ""
            )
        }
    }
    
}


// MARK: - Network data subscribers

extension NotificationsViewModel {
    
    private func subscribeOnNotifications() {
        fetchNotifications()
            .withLatestFrom(notificationsDataStorage.asDriverOnErrorJustComplete()) { dto, storage in
                return (dto, storage)
            }
        // Save data to storage
            .do(self) { (owner, arg1) in
                var (notifications, storage) = arg1
                storage.append(contentsOf: notifications)
                owner.notificationsDataStorage.onNext(storage)
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Subscribers from Input

extension NotificationsViewModel {
    
    // Set paginated counter
    private func subscribeOnReachedBottom(_ input: Input) {
        input.reachedBottom
        // Filter when product loading
            .withLatestFrom(activityTracker.asDriver())
            .filter { !$0 }
            .withLatestFrom(paginationCounter.asDriverOnErrorJustComplete())
            .withLatestFrom(notificationsDataStorage.asDriverOnErrorJustComplete()) { paginationCounter, collectionData in
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
    
    // MARK: - Switch to other screens, by tap on cell
    
    private func subscribeOnItemSelected(_ input: Input) {
        input.selectById
            .withLatestFrom(notificationsDataStorage.asDriverOnErrorJustComplete()) { id, arrayData in
                return (id, arrayData)
            }
            .compactMap { id, arrayData in
                arrayData.first { $0.id == id }
            }
            .map { $0.mapToScreenSwitchType() }
            .do(self) { owner, switchScreenType in
                switch switchScreenType {
                case .sales(let input):
                    owner.navigator.toSales(with: input)
                case .inventory(let input):
                    owner.navigator.toInventory(with: input)
                case .none:
                   print("Unknown screen")
                }
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnItemDeleted(_ input: Input) {
        input.removeById.withLatestFrom(notificationsDataStorage.asDriverOnErrorJustComplete()) { id, arrayData in
            return (id, arrayData)
        }
        // Remove request
        .map { $0 }
        .map { id, arrayData in
            var arrayData = arrayData
            arrayData.removeAll(where: { $0.id == id })
            return arrayData
        }
        .drive(notificationsDataStorage)
        .disposed(by: disposeBag)
        
    }
    
}

// MARK: - Requests

extension NotificationsViewModel {
    
    private func fetchNotifications() -> Driver<[NotificationDTO]> {
        paginationCounter
            .compactMap { $0 }
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
            .flatMapLatest(weak: self) { owner, paginatedData in
                owner.notificationsUseCase
                    .getNotifications(paginatedData)
                    .trackActivity(owner.activityTracker)
                    .trackError(owner.errorTracker)
                    .asDriverOnErrorJustComplete()
//                return Driver.just(owner.makeMokeData())
            }
    }
    
    private func makeMokeData() -> [NotificationDTO] {
      [
        .init(
            id: 3,
            date: "2024-07-04T09:55:51.20724",
            type: "Order",
            orderData: .init(
                name: "Joe & Seph's Milk Chocolate Popcorn Bites 3 Pack - Salted Caramel Popcorn 63g", 
                asin: "B084PFXT37",
                amazonOrderId: "202-6225633-1173940",
                eventType: "Pending",
                amount: 33.2
            )
        ),
        .init(
            id: 44,
            date: "2024-07-04T10:32:51.20724",
            type: "Product",
            productData: .init(
                name: "Joe & Seph's Milk Chocolate Popcorn Bites 3 Pack - Salted Caramel Popcorn 63g",
                asin: "B08KTM3XGL",
                eventType: "Title changed"
            )
        ),
        .init(
            id: 123,
            date: "2024-07-02T06:45:51.20724",
            type: "Order",
            orderData: .init(
                name: "Joe & Seph's Milk Chocolate Popcorn Bites 3 Pack - Salted Caramel Popcorn 63g",
                asin: "B084PFXT37",
                amazonOrderId: "026-1232137-6598727",
                eventType: "Refunded",
                amount: 33.2
            )
        ),
        .init(
            id: 43,
            date: "2024-07-01T10:55:51.20724",
            type: "Order",
            orderData: .init(
                name: "Joe & Seph's Milk Chocolate Popcorn Bites 3 Pack - Salted Caramel Popcorn 63g",
                asin: "B084PFXT37",
                amazonOrderId: "202-6225633-1173940",
                eventType: "Pending",
                amount: 22.4
            )
        ),
        .init(
            id: 34343,
            date: "2024-07-01T09:32:51.20724",
            type: "Product",
            productData: .init(
                name: "Joe & Seph's Milk Chocolate Popcorn Bites 3 Pack - Salted Caramel Popcorn 63g",
                asin: "B084PFNMK37",
                eventType: "Title changed"
            )
        ),
        .init(
            id: 12323,
            date: "2024-07-01T06:45:51.20724",
            type: "Order",
            orderData: .init(
                name: "Joe & Seph's Milk Chocolate Popcorn Bites 3 Pack - Salted Caramel Popcorn 63g",
                asin: "B084PFXT37",
                amazonOrderId: "202-6225633-1173940",
                eventType: "Refunded",
                amount: 32.2
            )
        ),
        .init(
            id: 12322443,
            date: "2024-07-01T06:45:51.20724",
            type: "Order",
            orderData: .init(
                name: "Joe & Seph's Milk Chocolate Popcorn Bites 3 Pack - Salted Caramel Popcorn 63g",
                asin: "B084PFXT37",
                amazonOrderId: "202-6225633-1173940",
                eventType: "Refunded",
                amount: 23.2
            )
        )
      ]
    }
    
}


// MARK: - Input Output

extension NotificationsViewModel {
    
    struct Input {
        // viewDidAppear or swipe
        let reloadData: Driver<Void>
        // currently visible collection section
        let reachedBottom: Driver<Void>
        // table view actions
        let selectById: Driver<Int>
        let removeById: Driver<Int>
    }
    
    struct Output {
        let tableData: Driver<[NotificationsSectionModel]>
        // Bottom loader
        let isShowPaginatedLoader: Driver<Bool>
        let clearAllButtonConfig: Driver<DefaultBarButtonItem.Config>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
    }
    
}
