//
//  ImageControlView.swift
//  SKUify
//
//  Created by George Churikov on 30.01.2024.
//

import Foundation
import UIKit

final class ImageControlView: UIView {

    // MARK: - UI elements
    
    private lazy var imageView = UIImageView()
    private lazy var uploadButton = DefaultButton()
    private lazy var removeButton = DefaultButton()
    
    private lazy var uploadImageStack = HorizontalStack()
    private lazy var contentStack = HorizontalStack()
    
    private let baseImageSize: CGSize = .init(
        width: 40.0,
        height: 40.0
    )
    
    private var isImageExpandable = false {
        didSet {
            updateImageSize()
        }
    }
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentStack()
        setupUploadImageStack()
        setupImageView()
        setupOnImageTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInput(_ input: Input) {
        setupImage(input)
        uploadButton.config = input.uploadButtonConfig
        removeButton.config = input.removeButtonConfig
    }
    
    // MARK: - Setup views

    private func setupImage(_ input: Input) {
        switch input.imageType {
        case .fromData(let data):
            imageView.image = UIImage(data: data)
        case .fromURL(let url):
            imageView.sd_setImage(
                with: url,
                placeholderImage: input.placeholderType.image
            )
        }
    }
    
    private func setupOnImageTap() {
        imageView.addTapGestureRecognizer { [weak self] in
            guard let self else { return }
            self.isImageExpandable = !self.isImageExpandable
        }
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.tintColor = .primary
        imageView.snp.makeConstraints { make in
            make.size
                .equalTo(baseImageSize)
        }
    }
    
    private func setupUploadImageStack() {
        uploadImageStack.views = [
            imageView,
            uploadButton
        ]
        uploadImageStack.spacing = 5

        // Set constraints for uploadButton
        uploadButton.setContentHuggingPriority(.required, for: .horizontal)
        uploadButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
    }
    
    private func setupContentStack() {
        contentStack.views = [
            uploadImageStack,
            removeButton
        ]
        contentStack.spacing = 5
        
        addSubview(contentStack)
        contentStack.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    private func updateImageSize() {
        
        let fullSize: CGSize = .init(
            width: frame.width,
            height: frame.width
        )
        
        let size: CGSize = isImageExpandable ?
        fullSize : baseImageSize
        
        let axis: NSLayoutConstraint.Axis = self.isImageExpandable ?
            .vertical :
            .horizontal

        UIViewPropertyAnimator(
            duration: 0.4,
            curve: UIView.AnimationCurve.linear,
            animations: { [weak self] in

                self?.imageView.snp.remakeConstraints { make in
                    make.size.equalTo(size)
                }
                self?.uploadImageStack.axis = axis
                self?.contentStack.axis = axis
                self?.layoutIfNeeded()
            }
        )
        .startAnimation()
    }
}

// MARK: - Input

extension ImageControlView {
    struct Input {
        var imageType: ImageType
        let placeholderType: PlaceholderType
        let uploadButtonConfig: DefaultButton.Config
        let removeButtonConfig: DefaultButton.Config
    }
    
    enum ImageType {
        case fromURL(_ url: URL?)
        case fromData(_ data: Data)
    }
    
    enum PlaceholderType {
        case person
        
        fileprivate var image: UIImage? {
            switch self {
            case .person:
                return UIImage(systemName: "person.crop.circle.fill")
            }
        }
    }
    
}

