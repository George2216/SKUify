//
//  SimpleTableViewCell.swift
//  SKUify
//
//  Created by George Churikov on 20.05.2024.
//

import Foundation
import SnapKit
import UIKit

final class SimpleTableViewCell: UITableViewCell {
    
    // MARK: - UI elements
    
    private let titleLabel = UILabel()
    
    // MARK: - Initializers
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        selectionStyle = .gray
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup input

    func setupTitle(_ title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private methods
    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .bold,
            size: 14
        )
        titleLabel.textColor = .textColor
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(10)
        }
    }
    
}
