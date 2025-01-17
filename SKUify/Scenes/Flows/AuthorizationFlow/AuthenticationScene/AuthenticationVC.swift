//
//  LoginVC.swift
//  SKUify
//
//  Created by George Churikov on 16.11.2023.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthenticationVC: BaseViewController {
    
    // Dependencies
    
    var viewModel: AuthenticationViewModel!

    // MARK: - UI Elements
    
    private lazy var scrollDecorator = ScrollDecorator(view)
    private lazy var containerView = scrollDecorator.containerView
    private lazy var scrollView = scrollDecorator.scrollView

    private lazy var titleLabel = UILabel()
    private lazy var subtitleLabel = UILabel()
    private lazy var labelsContainer = VerticalStack()
        
    private lazy var loginView = LoginView()
    private lazy var passwordRecoveryView = PasswordRecoveryView()
    private lazy var passwordRecoveryResultView = PasswordRecoveryResultView()
    private lazy var signUpView = SignUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage.titleImage)
        
        let output = viewModel.transform(AuthenticationViewModel.Input())

        setupTitleLabel()
        setupSubtitleLabel()
        setupLabelsContainer()
        
        bindToTitleLabel(output)
        bindToSubitleLabel(output)
        
        bindLoginView(output)
        bindPasswordRecoveryView(output)
        bindPasswordRecoveryResultView(output)
        bindSignUpView(output)
        
        bindToLoginView(output)
        bindToPasswordRecoveryView(output)
        bintToPasswordRecoveryResultView(output)
        bindToSignUpView(output)
        
        bindHeightForScrollingToTxtField(output)
        
        bindToBanner(output)
        bindToLoader(output)
    }

    private func bindToBanner(_ output: AuthenticationViewModel.Output) {
        output.error
            .drive(rx.banner)
            .disposed(by: disposeBag)
    }
    
    private func bindToLoader(_ output: AuthenticationViewModel.Output) {
        output.fetching
            .drive(rx.loading)
            .disposed(by: disposeBag)
    }
    
    // MARK: Make main view by state

    private func bindLoginView(_ output: AuthenticationViewModel.Output) {
        output.toLogin
            .drive(with: self) { owner, _ in
                owner.setupMainView(owner.loginView)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindPasswordRecoveryView(_ output: AuthenticationViewModel.Output) {
        output.toRecoveryPassword
            .drive(with: self) { owner, _ in
                owner.setupMainView(owner.passwordRecoveryView)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindPasswordRecoveryResultView(_ output: AuthenticationViewModel.Output) {
        output.toRecoveryPasswordResult
            .drive(with: self) { owner, _ in
                owner.setupMainView(owner.passwordRecoveryResultView)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSignUpView(_ output: AuthenticationViewModel.Output) {
        output.toSignUp
            .drive(with: self) { owner, _ in
                owner.setupMainView(owner.signUpView)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: Make binding to views
    
    private func bindToTitleLabel(_ output: AuthenticationViewModel.Output) {
        output.titleLabelText
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToSubitleLabel(_ output: AuthenticationViewModel.Output) {
        output.subtitleLabelText
            .drive(subtitleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindToLoginView(_ output: AuthenticationViewModel.Output) {
        output.loginInput
            .drive(loginView.rx.input)
            .disposed(by: disposeBag)
    }
    
    private func bindToPasswordRecoveryView(_ output: AuthenticationViewModel.Output) {
        output.passwordRecoveryInput
            .drive(passwordRecoveryView.rx.input)
            .disposed(by: disposeBag)
    }
    
    private func bintToPasswordRecoveryResultView(_ output: AuthenticationViewModel.Output) {
        output.passwordRecoveryResultInput
            .drive(passwordRecoveryResultView.rx.input)
            .disposed(by: disposeBag)
    }
    
    private func bindToSignUpView(_ output: AuthenticationViewModel.Output) {
        output.signUpInput
            .drive(signUpView.rx.input)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Bind keyboard height to scroll
    
    private func bindHeightForScrollingToTxtField(_ output: AuthenticationViewModel.Output) {
        output.keyboardHeight
            .map(self) { owner, height in
                UIScrollView.ScrollToVisibleContext(
                    height: height,
                    view: owner.view
                )
            }
            .drive(scrollView.rx.scrollToVisibleTextField)
            .disposed(by: disposeBag)
    }
    
    // MARK: Setup views
    
    private func setupMainView(_ view: UIView) {
        loginView.removeFromSuperview()
        passwordRecoveryView.removeFromSuperview()
        passwordRecoveryResultView.removeFromSuperview()
        signUpView.removeFromSuperview()
        
        containerView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top
                .equalTo(labelsContainer.snp.bottom)
                .offset(30)
            make.horizontalEdges
                .equalToSuperview()
                .inset(16)
            make.bottom
                .equalToSuperview()
        }
    }
    
    private func setupLabelsContainer() {
        labelsContainer.views = [
            titleLabel,
            subtitleLabel
        ]
        labelsContainer.spacing = 5
        containerView.addSubview(labelsContainer)
        
        labelsContainer.snp.makeConstraints { make in
            make.top
                .horizontalEdges
                .equalToSuperview()
                .inset(19)
        }
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .manrope(
            type: .bold,
            size: 24
        )
        titleLabel.textColor = .textColor
        titleLabel.textAlignment = .center
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = .manrope(
            type: .semiBold,
            size: 16
        )
        subtitleLabel.textColor = .textColor
        subtitleLabel.textAlignment = .center
    }
    
}

