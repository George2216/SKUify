//
//  SalesViewModel.swift
//  SKUify
//
//  Created by George Churikov on 28.11.2023.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class SalesViewModel: ViewModelProtocol {
    
    // Dependencies
    private let navigator: SalesNavigatorProtocol
    
    // Use case storage
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: SalesUseCases,
        navigator: SalesNavigatorProtocol
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





