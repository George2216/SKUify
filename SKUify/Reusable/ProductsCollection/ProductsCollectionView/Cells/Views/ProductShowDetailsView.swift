//
//  ProductShowDetailsView.swift
//  SKUify
//
//  Created by George Churikov on 06.03.2024.
//

import UIKit
import SnapKit

final class ProductShowDetailsView: UIView {

    // MARK: - UI Elements

    private lazy var titleLabel = UILabel()
    private lazy var arrowImageView = UIImageView()
    
    // Rotate arrow image by isSelected changes
    var isSelected: Bool = false {
        didSet {
            transformArrowImage()
        }
    }
    
    //MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .primaryLight
        setupTitleLabel()
        setupArrowImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func transformArrowImage() {
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi / 2 )
            self.arrowImageView.transform = self.isSelected ? upsideDown : .identity
        }
    }
    
    // MARK: - Setup views
    
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
            make.leading
                .equalTo(titleLabel.snp.trailing)
            make.centerY
                .equalToSuperview()
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "View Details"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .primary

        titleLabel.font = .manrope(
            type: .bold,
            size: 13
        )
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(15)
        }
    }
    
}
