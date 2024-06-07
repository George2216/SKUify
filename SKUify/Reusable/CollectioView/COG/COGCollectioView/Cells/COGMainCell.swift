//
//  COGMainCell.swift
//  SKUify
//
//  Created by George Churikov on 02.04.2024.
//

import Foundation
import UIKit

final class COGMainCell: UICollectionViewCell {
    
    // MARK: - UI elements
    
    private lazy var imageView = UIImageView()

    private lazy var titlesView = COGTitlesView()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        setupImageView()
        setupTitlesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        setupTitlesView(input)
        setupImageView(input)
    }
    
    func setupWigth(_ width: CGFloat) {
        contentView.snp.makeConstraints { make in
            make.width
                .equalTo(width)
        }
    }
    
    // MARK: - Private methods

    private func setupTitlesView(_ input: Input) {
        titlesView.setupInput(input.content)
    }
    
    private func setupImageView(_ input: Input) {
        imageView.sd_setImage(with: input.imageUrl)
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.size
                .equalTo(120)
                .priority(.required)
            make.verticalEdges
                .greaterThanOrEqualToSuperview()
            make.centerY
                .equalToSuperview()
            make.leading
                .equalToSuperview()
                .offset(10)
        }
    }
    
    private func setupTitlesView() {
        contentView.addSubview(titlesView)
        titlesView.snp.makeConstraints { make in
            make.leading
                .equalTo(imageView.snp.trailing)
                .offset(10)
            make.verticalEdges
                .greaterThanOrEqualToSuperview()
                .inset(10)
            make.centerY
                .equalToSuperview()
            make.trailing
                .equalToSuperview()
                .inset(10)
        }
    }
    
    private func setupCell() {
        backgroundColor = .cellColor
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
}

// MARK: - Input

extension COGMainCell {
    struct Input {
        let imageUrl: URL?
        let content: COGTitlesView.Input
    }
    
}
