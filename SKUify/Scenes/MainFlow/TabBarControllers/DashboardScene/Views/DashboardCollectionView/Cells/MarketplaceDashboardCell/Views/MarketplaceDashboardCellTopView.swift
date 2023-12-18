//
//  MarketplaceDashboardCellTopView.swift
//  SKUify
//
//  Created by George Churikov on 13.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class MarketplaceDashboardCellTopView: UIView {

    // MARK: - UI Elements
    
    private lazy var titledMarketplace = TitledMarketplace()
    private lazy var arrowImageView = UIImageView()
    
    // Decorate titledMarketplace
    private lazy var titledMarketplaceDecorator = TitleDecorator(decoratedView: titledMarketplace)
    
    // Rotate arrow image by isSelected changes
    var isSelected: Bool = false {
        didSet {
            transformArrowImage()
        }
    }
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTitledMarketplaceDecorator()
        setupArrowImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInput(_ input: Input) {
        titledMarketplace.setMarketplace(input.marketplace)
        titledMarketplaceDecorator.decorate(title: input.title)
    }
    
    private func transformArrowImage() {
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi / 2 )
            self.arrowImageView.transform = self.isSelected ? upsideDown : .identity
        }
    }
    
    // MARK: Setup views

    private func setupArrowImageView() {
        arrowImageView.image = UIImage(systemName: "chevron.right")?
            .withConfiguration(
                UIImage.SymbolConfiguration(
                    font: .manrope(
                        type: .bold,
                        size: 15
                    ),
                    scale: .medium
                )
            )
        arrowImageView.contentMode = .scaleAspectFit
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.trailing
                .equalToSuperview()
            make.centerY
                .equalToSuperview()
        }

    }
    
    private func setupTitledMarketplaceDecorator() {
        addSubview(titledMarketplaceDecorator)
        titledMarketplaceDecorator.snp.makeConstraints { make in
            make.leading
                .directionalVerticalEdges
                .equalToSuperview()
        }
    }
   
}

// MARK: Input

extension MarketplaceDashboardCellTopView {
    struct Input {
        let title: String
        let marketplace: String
    }
}
