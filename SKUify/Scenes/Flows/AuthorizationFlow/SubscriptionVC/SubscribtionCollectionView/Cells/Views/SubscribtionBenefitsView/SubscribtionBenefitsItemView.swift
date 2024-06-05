//
//  SubscribtionBenefitsItemView.swift
//  SKUify
//
//  Created by George Churikov on 04.06.2024.
//

import Foundation
import UIKit
import SnapKit

final class SubscribtionBenefitsItemView: UIView {
    
    // MARK: - UI elements
    
    private lazy var checkImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCheckImageView()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set data

    func setupInput(_ input: Input) {
        titleLabel.text = input.title
    }
    
    // MARK: - Private methods

    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .medium,
            size: 12
        )
        titleLabel.textColor = .textColor
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading
                .equalTo(checkImageView.snp.trailing)
                .offset(10)
            make.trailing
                .equalToSuperview()
        }
    }
    
    private func setupCheckImageView() {
        checkImageView.image = UIImage.check
        checkImageView.contentMode = .scaleAspectFit
        
        addSubview(checkImageView)
        checkImageView.snp.makeConstraints { make in
            make.size
                .equalTo(18)
            make.verticalEdges
                .leading
                .equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension SubscribtionBenefitsItemView {
    struct Input {
        let title: String
    }
    
}
