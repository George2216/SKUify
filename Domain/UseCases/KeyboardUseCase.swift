//
//  KeyboardUseCase.swift
//  Domain
//
//  Created by George Churikov on 26.11.2023.
//

import Foundation
import RxSwift

public protocol KeyboardUseCase {
    func getKeyboardHeight() -> Observable<CGFloat> 
}
