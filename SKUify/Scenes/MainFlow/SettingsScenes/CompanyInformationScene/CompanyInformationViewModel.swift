//
//  CompanyInformationViewModel.swift
//  SKUify
//
//  Created by George Churikov on 29.01.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class CompanyInformationViewModel: ViewModelProtocol {
    
    // Dependencies
    private let navigator: CompanyInformationNavigatorProtocol
    
    // Use case storage
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: CompanyInformationUseCases,
        navigator: CompanyInformationNavigatorProtocol
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



