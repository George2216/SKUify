//
//  MarketplacesPopoverViewModel.swift
//  SKUify
//
//  Created by George Churikov on 01.03.2024.
//

import Foundation
import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class MarketplacesPopoverViewModel: ViewModelProtocol {
    private let disposeBag = DisposeBag()

    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
        
    func transform(_ input: Input) -> Output {
        return Output()
    }
    
  
    struct Input {
        
    }
    
    struct Output {
        
    }
    
}



