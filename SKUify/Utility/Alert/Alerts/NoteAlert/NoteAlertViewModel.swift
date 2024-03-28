//
//  NoteAlertViewModel.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class NoteAlertViewModel: ViewModelProtocol {
    
    private let keyboardUseCase: KeyboardUseCase
    
    init(useCases: NoteAlertUseCases) {
        keyboardUseCase = useCases.makeKeyboardUseCase()
    }
    
    func transform(_ input: Input) -> Output {
        return Output(keyboardHeight: makeKeyboardHeight())
    }
    
    private func makeKeyboardHeight() -> Driver<CGFloat> {
        keyboardUseCase
            .getKeyboardHeight()
            .asDriverOnErrorJustComplete()
    }
    
}

extension NoteAlertViewModel {
    struct Input { }
    
    struct Output {
        let keyboardHeight: Driver<CGFloat>
    }
    
}

