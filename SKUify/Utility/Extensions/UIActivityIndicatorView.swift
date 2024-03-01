//
//  UIActivityIndicatorView.swift
//  SKUify
//
//  Created by George Churikov on 29.02.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIActivityIndicatorView {
    var isAnimating: Binder<Bool> {
        return Binder(self.base) { indicator, isActive in
            isActive ? indicator.startAnimating() : indicator.stopAnimating()
        }
    }
    
}
