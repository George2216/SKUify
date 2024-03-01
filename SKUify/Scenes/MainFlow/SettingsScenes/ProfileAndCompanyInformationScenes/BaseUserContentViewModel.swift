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
    
    // MARK: - Base transform

    func transform(_ input: Input) -> Output {
        Output(
            navigationTitle: .empty(),
            keyboardHeight: .empty(),
            contentData: .empty(),
            tapOnUploadImage: .empty(),
            fetching: .empty(),
            error: .empty()
        )
    }
    
    // MARK: - Input Output

    struct Input {
        let updateImage: Driver<Data>
    }

    struct Output {
        let navigationTitle: Driver<String>
        // Scroll to
        let keyboardHeight: Driver<CGFloat>
        // Scroll content
        let contentData: Driver<UserContentContentView.Input>
        // Show image picker
        let tapOnUploadImage: Driver<Void>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
    }
    
}

