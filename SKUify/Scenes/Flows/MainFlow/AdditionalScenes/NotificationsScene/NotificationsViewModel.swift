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
    
    // Dependencies
    private let navigator: NotificationsNavigatorProtocol
    
    // Use case storage
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: NotificationsUseCases,
        navigator: NotificationsNavigatorProtocol
    ) {
        self.navigator = navigator
        
    }
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
}

// MARK: - Input Output

extension NotificationsViewModel {

struct Input {
    
}

struct Output {
    
}

}
