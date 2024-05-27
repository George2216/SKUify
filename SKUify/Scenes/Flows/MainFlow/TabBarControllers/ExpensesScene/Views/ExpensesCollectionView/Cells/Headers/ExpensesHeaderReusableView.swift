//
//  ExpensesHeaderReusableView.swift
//  SKUify
//
//  Created by George Churikov on 07.05.2024.
//

import Foundation
import UIKit
import SnapKit

final class ExpensesHeaderReusableView: UICollectionReusableView {
    
    // MARK: UI elements
    
    private let titleLabel = UILabel()
    
    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        titleLabel.text = input.title
    }
    
    // MARK: Private methods
    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .medium,
            size: 13
        )
        titleLabel.textColor = .textColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
}

// MARK: Input

extension ExpensesHeaderReusableView {
    struct Input {
        let title: String
    }
    
}
