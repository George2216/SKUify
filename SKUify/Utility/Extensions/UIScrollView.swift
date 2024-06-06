//
//  UIScrollView.swift
//  SKUify
//
//  Created by George Churikov on 27.11.2023.
//

import Foundation
import RxSwift
import UIKit

extension UIScrollView {
    struct ScrollToVisibleContext {
        var height: CGFloat
        var view: UIView
    }
}

extension Reactive where Base: UIScrollView {
    var scrollToVisibleTextField: Binder<UIScrollView.ScrollToVisibleContext> {
        return Binder(self.base) { scrollView, heightAndView in
//            let contentInsets = UIEdgeInsets(
//                top: 0.0,
//                left: 0.0,
//                bottom: heightAndView.height,
//                right: 0.0
//            )
//            scrollView.contentInset = contentInsets
//            scrollView.scrollIndicatorInsets = contentInsets
//
//            if let activeField = heightAndView.view
//                .findFirstResponderTxtField() {
//                let activeRect = activeField.convert(
//                    activeField.bounds,
//                    to: scrollView
//                )
//                scrollView.scrollRectToVisible(
//                    activeRect,
//                    animated: true
//                )
//            }
        }
    }
}


