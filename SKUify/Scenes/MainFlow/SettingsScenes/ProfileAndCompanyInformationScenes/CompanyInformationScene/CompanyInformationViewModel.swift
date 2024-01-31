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

final class CompanyInformationViewModel: BaseUserContentViewModel {
    
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
    
    override func transform(_ input: Input) -> Output {
        _ = super.transform(input)
        return Output(
            contentData: .empty(),
            tapOnUploadImage: .empty(),
            fetching: .empty(),
            error: .empty()
        )
    }
    
}



