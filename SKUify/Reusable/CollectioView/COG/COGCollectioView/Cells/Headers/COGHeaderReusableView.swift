//
//  COGHeaderReusableView.swift
//  SKUify
//
//  Created by George Churikov on 02.05.2024.
//

import Foundation
import UIKit
import SnapKit

final class COGHeaderReusableView: UICollectionReusableView {
    
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
            type: .extraBold,
            size: 15
        )
        titleLabel.textColor = .textColor
        titleLabel.textAlignment = .left
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(10)
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
}

// MARK: Input

extension COGHeaderReusableView {
    struct Input {
        let title: String
    }
    
}
