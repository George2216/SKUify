//
//  ImageUploadView.swift
//  SKUify
//
//  Created by George Churikov on 19.01.2024.
//

import UIKit
import SnapKit

final class ImageUploadView: UIView {

    // MARK: - UI elements
    
    private lazy var imageView = UIImageView()
    private lazy var uploadButton = DefaultButton()
    
    private lazy var contentStack = HorizontalStack()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
        setupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        imageView.image = try? UIImage(url: input.imageUrl)
        uploadButton.config = input.uploadButtonConfig
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints { make in
            make.size
                .equalTo(40)
        }
    }
    
    private func setupContentStack() {
        contentStack.views = [
            imageView,
            uploadButton
        ]
        contentStack.spacing = 5
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
}

// MARK: - Input

extension ImageUploadView {
    struct Input {
        let imageUrl: URL
        let uploadButtonConfig: DefaultButton.Config
    }
    
}
