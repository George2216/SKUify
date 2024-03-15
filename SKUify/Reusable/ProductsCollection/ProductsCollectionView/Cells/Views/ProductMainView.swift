//
//  ProductMainView.swift
//  SKUify
//
//  Created by George Churikov on 14.02.2024.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

final class ProductMainView: UIView {
    
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
                .priority(.high)
        }
    }
    
    private func setupContentStack() {
        contentStack.views = [
            imageView,
            titlesView
        ]
        
        contentStack.distribution = .fill
        contentStack.spacing = 10
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
}

// MARK: - Input

extension ProductMainView {
    struct Input {
        var imageUrl: URL?
        var titlesViewInput: ProductTitlesView.Input
    }
    
}
