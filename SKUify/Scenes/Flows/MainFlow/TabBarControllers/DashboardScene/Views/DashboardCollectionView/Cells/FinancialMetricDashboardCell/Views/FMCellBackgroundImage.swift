//
//  FMCellBackgroundImage.swift
//  SKUify
//
//  Created by George Churikov on 04.12.2023.
//

import Foundation
import UIKit
import SnapKit

final class FMCellBackgroundImage: UIView {
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addSubviewImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    private func addSubviewImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
            make.width
                .height
                .equalTo(16)
        }
    }
    
    private func setupView() {
        backgroundColor = .border
        clipsToBounds = true
        layer.cornerRadius = 16
        snp.makeConstraints { make in
            make.width
                .height
                .equalTo(32)
        }
    }
}
