//
//  ImageUploadView.swift
//  SKUify
//
//  Created by George Churikov on 19.01.2024.
//

import UIKit
import SnapKit
import SDWebImage

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
        setupImage(input)
        uploadButton.config = input.uploadButtonConfig
    }
    
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
    
     private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.tintColor = .primary
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
        var imageType: ImageType
        let placeholderType: PlaceholderType
        let uploadButtonConfig: DefaultButton.Config
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
