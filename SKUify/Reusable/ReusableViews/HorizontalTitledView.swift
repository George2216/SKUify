//
//  HorizontalTitledView.swift
//  SKUify
//
//  Created by George Churikov on 02.04.2024.
//

import Foundation
import UIKit
import SnapKit

final class HorizontalTitledView: UIView {
    
    // MARK: UI elements
    
    private lazy var titleDecorator = TitleDecorator(
        decoratedView: decoratedView,
        font: .manrope(
            type: .bold,
            size: 13
        ),
        textColor: .textColor,
        spacing: 10.0, // minimal spacing
        axis: .horizontal
    )
    
    private var decoratedView: UIView
    
    // MARK: Initializers
    
    convenience init(
        title: String,
        decoratedView: UIView,
        font: UIFont =  .manrope(
            type: .bold,
            size: 13
        )
    ) {
        self.init(frame: .zero)
        self.decoratedView = decoratedView
        setupTitleDecorator()
        titleDecorator.decorate(title: title)
    }
    
    override init(frame: CGRect) {
        decoratedView = UIView()
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setupTitleDecorator() {
        addSubview(titleDecorator)
        titleDecorator.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}
