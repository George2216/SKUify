//
//  DashboardViewModel.swift
//  SKUify
//
//  Created by George Churikov on 20.11.2023.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

final class DashboardViewModel: ViewModelProtocol {
    
    // Dependencies
    private let navigator: DashboardNavigatorProtocol
    
    // Use case storage
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        dashboardUseCases: DashboardUseCases,
        navigator: DashboardNavigatorProtocol
    ) {
        self.navigator = navigator
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
    struct Input {
        
    }
    
    struct Output {
    }
    
}



