//
//  COGBaseViewModel.swift
//  SKUify
//
//  Created by George Churikov on 03.05.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

class COGBaseViewModel: ViewModelProtocol {
    
    func transform(_ input: Input) -> Output {
        .init(
            title: .empty(),
            collectionData: .empty(),
            showCalendarPopover: .empty(), 
            alert: .empty(),
            keyboardHeight: .empty(),
            fetching: .empty(),
            error: .empty()
        )
    }
    
}

// MARK: - Input Output

extension COGBaseViewModel {
    
    struct Input {
        let selectedCalendarDate: Driver<Date>
    }
    
    struct Output {
        let title: Driver<String>
        let collectionData: Driver<[COGSectionModel]>
        let showCalendarPopover: Driver<CGPoint>
        // Show Alert
        let alert: Driver<AlertManager.AlertType>
        // Use for scroll to textfield
        let keyboardHeight: Driver<CGFloat>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
    }
    
}



