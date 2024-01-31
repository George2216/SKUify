//
//  BaseUserContentViewModel.swift
//  SKUify
//
//  Created by George Churikov on 31.01.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BaseUserContentViewModel: ViewModelProtocol {
    
    func transform(_ input: Input) -> Output {
        Output(
            contentData: .empty(),
            tapOnUploadImage: .empty(),
            fetching: .empty(),
            error: .empty()
        )
    }
    
    struct Input {
        let updateImage: Driver<Data>
    }

    struct Output {
        let contentData: Driver<UserContentContentView.Input>
        let tapOnUploadImage: Driver<Void>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
    }
    
}

