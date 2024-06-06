//
//  SubscriptionViewModel.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class SubscriptionViewModel: ViewModelProtocol {
    
    // Dependencies
    private let navigator: SubscriptionNavigatorProtocol
    
    // Use case storage
    private let subscribtionsUseCase: Domain.SubscriptionsUseCase
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: SubscriptionUseCase,
        navigator: SubscriptionNavigatorProtocol
    ) {
        self.navigator = navigator
        self.subscribtionsUseCase = useCases.makeSubscriptionsUseCase()
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            title: makeTitle(),
            collectionData: makeCollectionData(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error)
        )
    }
    
    private func makeTitle() -> Driver<String> {
        .just("Subscribe to our plan")
    }
    
}

// MARK: - Make collection data

extension SubscriptionViewModel {
    
    private func makeCollectionData() -> Driver<[SubscriptionSectionModel]> {
        fetchSubscribtions()
            .map(self) { owner, subscribtions in
                return subscribtions.map { supscription in
                    return .init(
                        model: .defaultSection(
                            header: "",
                            footer: ""
                        ),
                        items: [
                            owner.makeSubscriptionInput(supscription)
                        ]
                    )
                    
                }
            }
    }
    
    private func makeSubscriptionInput(_ subscription: SubscriptionDTO) -> SubscribtionCollectionItem {
        .subscribtion(
            .init(
                titleViewInput: .init(
                    imageURL: URL(string: subscription.iconUrl),
                    title: subscription.title,
                    subtitle: subscription.subtitle,
                    price: subscription.currency.symbol + String(subscription.price),
                    period: "/" + subscription.intervalUnit
                ),
                benifistsInput: .init(
                    benefits: subscription.list.map { title in
                        return .init(title: title)
                    }
                ),
                subscribeButtonConfig: .init(
                    title: "Subscribe",
                    style: .fullyRoundedPrimary,
                    action: .simple({
                        
                    })
                )
            )
        )
    }
    
}

// MARK: - Requests

extension SubscriptionViewModel {
    
    func fetchSubscribtions() -> Driver<[SubscriptionDTO]> {
        subscribtionsUseCase
            .getSubscriptions()
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
    }
    
}

// MARK: - Input Output

extension SubscriptionViewModel {
    struct Input { }
    
    struct Output {
        let title: Driver<String>
        // Subscribtions data
        let collectionData: Driver<[SubscriptionSectionModel]>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
    }
    
}


