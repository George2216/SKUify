//
//  ExpensesViewModel.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import RxSwift

final class ExpensesViewModel: ViewModelProtocol {
    
    // Dependencies
    private let navigator: ExpensesNavigatorProtocol
    
    // Use case storage
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: ExpensesUseCases,
        navigator: ExpensesNavigatorProtocol
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



