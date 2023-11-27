//
//  KeyboardUseCase.swift
//  AppEventsPlatform
//
//  Created by George Churikov on 27.11.2023.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class KeyboardUseCase: Domain.KeyboardUseCase {
    func getKeyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from(
                [
                    NotificationCenter.default.rx
                        .notification(UIResponder.keyboardWillShowNotification)
                        .map { notification -> CGFloat in
                            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                        },
                    NotificationCenter.default.rx
                        .notification(UIResponder.keyboardWillHideNotification)
                        .map { _ -> CGFloat in
                            0
                        }
                ]
            )
            .merge()
    }
}
