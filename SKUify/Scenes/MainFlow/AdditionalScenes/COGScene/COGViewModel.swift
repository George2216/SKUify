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

final class COGViewModel: ViewModelProtocol {
    
    // Dependencies
    private let navigator: COGNavigatorProtocol
    
    // Use case storage
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: COGUseCases,
        navigator: COGNavigatorProtocol
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



