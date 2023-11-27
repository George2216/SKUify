//
//  HorizontalStack.swift
//  SKUify
//
//  Created by George Churikov on 24.11.2023.
//
import UIKit
import RxSwift
import RxCocoa

class HorizontalStack: UIStackView {

    var views: [UIView]  {
        get { arrangedSubviews }
        set {
            arrangedSubviews.forEach { $0.removeFromSuperview() }
            newValue.forEach { addArrangedSubview($0) }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .horizontal
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension Reactive where Base: HorizontalStack {
    var views: Binder<[UIView]> {
        return Binder(self.base) { stack, arrangedSubviews in
            stack.views = arrangedSubviews
        }
    }
}
