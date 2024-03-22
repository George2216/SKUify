//
//  ProductMainCell.swift
//  SKUify
//
//  Created by George Churikov on 06.03.2024.
//

import Foundation
import UIKit
import SnapKit

final class ProductMainCell: UICollectionViewCell {
    
    // MARK: - UI elements
    
    private lazy var imageView = UIImageView()
    private lazy var titlesView = ProductTitlesView()
    private lazy var contentStack = HorizontalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        setupImageView(input)
        setupTitlesView(input)
    }
    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
            make.edges
                .equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        roundCorners(
            [
                .topLeft,
                .topRight
            ],
            radius: 15
        )
    }
    
    private func setupImageView(_ input: Input) {
        imageView.sd_setImage(with: input.imageUrl)
    }
    
    private func setupTitlesView(_ input: Input) {
        titlesView.setupInput(input.titlesViewInput)
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size
                .equalTo(70)
                .priority(.required)
        }
    }
    
    private func setupContentStack() {
        contentStack.views = [
            imageView,
            titlesView
        ]
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        contentStack.spacing = 10

        contentView.addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(10)
        }
    }
}

// MARK: - Input

extension ProductMainCell {
    struct Input {
        var imageUrl: URL?
        var titlesViewInput: ProductTitlesView.Input
    }
    
}
