//
//  ProfileViewModel.swift
//  SKUify
//
//  Created by George Churikov on 18.01.2024.
//

import Foundation

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class ProfileViewModel: ViewModelProtocol {
    
    // Dependencies
    private let navigator: ProfileNavigatorProtocol
    
    // Use case storage
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: ProfileUseCases,
        navigator: ProfileNavigatorProtocol
    ) {
        self.navigator = navigator
        
    }
    
    func transform(_ input: Input) -> Output {
        return Output(contentData: makeContentData())
    }
    
    private func makeContentData() -> Driver<ProfileContentView.Input> {
        .just(
            .init(
                profileHeaderViewInput: .init(
                    uploadInput: .init(
                        imageUrl: URL(string: "https://t4.ftcdn.net/jpg/03/83/25/83/360_F_383258331_D8imaEMl8Q3lf7EKU2Pi78Cn0R7KkW9o.jpg")!,
                        uploadButtonConfig: .init(
                            title: "Upload new picture",
                            style: .primaryPlus,
                            action: {
                                
                            }
                        )
                    ),
                    removeButtonConfig: .init(
                        title: "Remove",
                        style: .simple,
                        action: {
                            
                        }
                    )
                ),
                fieldsConfigs: [
                    .init(title: "Full Name",
                          config: .init(
                            style: .bordered,
                            textObserver: { text in
                                
                            }
                          )
                         ),
                    .init(title: "Email",
                          config: .init(
                            style: .bordered,
                            textObserver: { text in
                                
                            }
                          )
                         ),
                    .init(title: "Mobile Number",
                          config: .init(
                            style: .bordered,
                            textObserver: { text in
                                
                            }
                          )
                         )
                ],
                saveButtonConfig: .just(
                    .init(
                        title: "Save",
                        style: .primary,
                        action: {
                            
                        }
                    )
                )
            )
        )
    }
   
    
}



extension ProfileViewModel {
    struct Input {
        
    }
    
    struct Output {
        let contentData: Driver<ProfileContentView.Input>
    }
}
