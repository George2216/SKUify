//
//  ProfileVC.swift
//  SKUify
//
//  Created by George Churikov on 18.01.2024.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxExtensions
import SDWebImage

final class UserContentVC: BaseViewController {
    
    // Dependencies
    var viewModel: BaseUserContentViewModel!
    
    // MARK: UI elements
    
    private lazy var scrollDecarator = ScrollDecorator(view)
    private lazy var containerView = scrollDecarator.containerView
    private lazy var scrollView = scrollDecarator.scrollView

    private lazy var contentView = UserContentContentView()
    
    private let updateImage = PublishSubject<Data>()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        let output = viewModel.transform(.init(updateImage: updateImage.asDriverOnErrorJustComplete()))
        setupContentView()
        
        bindHeightForScrollingToTxtField(output)
        bindToContentView(output)
        bindToLoader(output)
        bindToBanner(output)
        bindOnImagePicker(output)
    }
    
    // MARK: - Setup views
        
    private func setupContentView() {
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.horizontalEdges
                .equalToSuperview()
                .inset(16)
            make.bottom
                .equalToSuperview()
        }
    }
    
}


// MARK: Make binding

extension UserContentVC {
    
    private func bindHeightForScrollingToTxtField(_ output: ProfileViewModel.Output) {
        output.keyboardHeight
            .withUnretained(self)
            .map { owner, height in
                UIScrollView.ScrollToVisibleContext(
                    height: height,
                    view: owner.view
                )
            }
            .drive(scrollView.rx.scrollToVisibleTextField)
            .disposed(by: disposeBag)
    }
    
    private func bindToLoader(_ output: ProfileViewModel.Output) {
        output.fetching
            .drive(rx.loading)
            .disposed(by: disposeBag)
    }
    
    private func bindToBanner(_ output: ProfileViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
    private func bindToContentView(_ output: ProfileViewModel.Output) {
        output.contentData
            .drive(contentView.rx.input)
            .disposed(by: disposeBag)
    }
    
    private func bindOnImagePicker(_ output: ProfileViewModel.Output) {
        output.tapOnUploadImage
            .flatMap(weak: self, selector: { owner, _ in
                return UIImagePickerController.rx.createWithParent(owner) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                }
                .flatMap {
                    $0.rx.didFinishPickingMediaWithInfo
                }
            })
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: true)
            })
            .compactMap { info in
                return info[.originalImage] as? UIImage
            }
            .compactMap { image in
                image.jpegData(compressionQuality: 0.1)
            }
            .drive(updateImage)
            .disposed(by: disposeBag)
    }
    
}

