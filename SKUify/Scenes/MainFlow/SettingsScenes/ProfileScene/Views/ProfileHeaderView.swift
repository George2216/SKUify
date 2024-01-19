//
//  ProfileHeaderView.swift
//  SKUify
//
//  Created by George Churikov on 18.01.2024.
//

import UIKit

final class ProfileHeaderView: UIView {

    // MARK: - UI elements
    
    private lazy var imageUploadView = ImageUploadView()
    private lazy var removeButton = DefaultButton()
    
    private lazy var contentStack = HorizontalStack()
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        imageUploadView.setupInput(input.uploadInput)
        removeButton.config = input.removeButtonConfig
    }
    
    // MARK: - Setup views

    private func setupContentStack() {
        contentStack.views = [
            imageUploadView,
            UIView.spacer(),
            removeButton
        ]
        addSubview(contentStack)
        
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
}

// MARK: - Input

extension ProfileHeaderView {
    struct Input {
        let uploadInput: ImageUploadView.Input
        let removeButtonConfig: DefaultButton.Config
    }
}

