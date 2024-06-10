//
//  LoginViewModel.swift
//  SKUify
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class AuthenticationViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    private let screenState = BehaviorSubject<ScreenState>(value: .login)
    
    // MARK: - Login properties
    
    private let loginEmail = PublishSubject<String>()
    private let loginPassword = PublishSubject<String>()
    
    private var loginFieldsText: Driver<(String, String)> {
        Driver.combineLatest(
            loginEmail.asDriverOnErrorJustComplete(),
            loginPassword.asDriverOnErrorJustComplete()
        )
    }
    
    private let loginIsRememberMeStorage = BehaviorSubject<Bool>(value: false)
    
    private let loginTrigger = PublishSubject<Void>()
    
    private let resetPasswordTrigger = PublishSubject<Void>()
    
    // MARK: - Forgot password properties
    
    private let passwordRecoveryEmail = PublishSubject<String>()
    
    // MARK: - Sign up properties
    
    private let signUpFirstName = PublishSubject<String>()
    private let signUpLastName = PublishSubject<String>()
    private let signUpEmail = PublishSubject<String>()
    private let signUpPassword = PublishSubject<String>()
    private let signUpConfirmPassword = PublishSubject<String>()
    
    private var signUpFieldsText: Driver<(String, String, String, String, String)> {
        Driver.combineLatest(
            signUpFirstName.asDriverOnErrorJustComplete(),
            signUpLastName.asDriverOnErrorJustComplete(),
            signUpEmail.asDriverOnErrorJustComplete(),
            signUpPassword.asDriverOnErrorJustComplete(),
            signUpConfirmPassword.asDriverOnErrorJustComplete()
        )
    }
    
    private let signUpIsAgreeStorage = BehaviorSubject<Bool>(value: false)
    
    // Dependencies
    private var navigator: AuthenticationNavigatorProtocol
    
    // Use case storage
    
    private let loginUseCase: Domain.LoginUseCase
    private let loginStateUseCase: Domain.LoginStateUseCase
    private let keyboardUseCase: Domain.KeyboardUseCase
    private let resetPasswordUseCase: Domain.ResetPasswordUseCase
    
    // Trackers
    private var activityTracker = ActivityTracker()
    private var loginErrorTracker = ErrorTracker()
    
    init(
        useCases: AuthenticationUseCases,
        navigator: AuthenticationNavigatorProtocol
    ) {
        self.navigator = navigator
        self.loginUseCase = useCases.makeLoginUseCase()
        self.loginStateUseCase = useCases.makeLoginStateUseCase()
        self.keyboardUseCase = useCases.makeKeyboardUseCase()
        self.resetPasswordUseCase = useCases.makeResetPasswordUseCase()
        
        subscribeOnLogin()
        subscribeOnResetPassword()
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            keyboardHeight: getKeyboardHeight(),
            titleLabelText: setupTitleLabelText(),
            subtitleLabelText: setupSubtitleLabelText(),
            toLogin: toLoginView(),
            toRecoveryPassword: toRecoveryPasswordView(),
            toRecoveryPasswordResult: toRecoveryPasswordResultView(),
            toSignUp: toSignUpView(),
            loginInput: makeLoginInput(),
            passwordRecoveryInput: makePasswordRecoveryInput(),
            passwordRecoveryResultInput: makePasswordRecoveryResultInput(),
            signUpInput: makeSignUpInput(),
            fetching: activityTracker.asDriver(),
            error: loginErrorTracker.asBannerInput()
        )
    }
    
    // MARK: - Make labels methods
    
    private func setupTitleLabelText() -> Driver<String> {
        screenState
            .map({ $0.titleText })
            .asDriverOnErrorJustComplete()
    }
    
    private func setupSubtitleLabelText() -> Driver<String> {
        screenState
            .map({ $0.subtitleText })
            .asDriverOnErrorJustComplete()
    }
    
    // MARK: Make views changes by state
    
    private func toLoginView() -> Driver<Void> {
        screenState
            .filterEqual(.login)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
    
    private func toRecoveryPasswordView() -> Driver<Void> {
        screenState
            .filterEqual(.recoveryPassword)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
    
    private func toRecoveryPasswordResultView() -> Driver<Void> {
        screenState
            .filterEqual(.recoveryPasswordResult)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
    
    private func toSignUpView() -> Driver<Void> {
        screenState
            .filterEqual(.signUp)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
    
    
    
    // Make button config without action
    private func makeBaseFullyRoundedPrimaryButtonConfig(_ title: String) -> DefaultButton.Config {
        return .init(
            title: title,
            style: .fullyRoundedPrimary
        )
    }
}

// MARK: - Login state methods

extension AuthenticationViewModel {
    
    private func makeLoginInput() -> Driver<LoginView.Input> {
        return .just(
            .init(
                loginTxtFieldConfigs: makeLoginTextFieldConfigs(),
                loginButtonConfig: makeLogInButtonConfig(),
                rememberMeButtonConfig: makeRememberMeButtonConfig(),
                forgotPasswordButtonConfig: makeForgotPusswordButtonConfig(),
                createAccountText: makeCreateAcountText(),
                createAccountButtonConfig: makeAccountButtonConfig()
                
            )
        )
    }
    
    private func makeLoginTextFieldConfigs() -> Driver<[TitledTextField.Config]> {
        Driver<[TitledTextField.Config]>.just([
            .init(
                title: "Email Adress",
                config: .init(
                    style: .bordered,
                    textObserver: { [weak self] text in
                        guard let self else { return }
                        self.loginEmail.onNext(text)
                    }
                )
            ),
            .init(
                title: "Password",
                config: .init(
                    style: .bordered,
                    textObserver: { [weak self] text in
                        guard let self else { return }
                        self.loginPassword.onNext(text)
                    }
                )
            )
        ])
    }
    
    // Login button config
    private func makeLogInButtonConfig() -> Driver<DefaultButton.Config> {
        return loginFieldsText
            .map(self) { owner, args in
                let (email, password) = args
                return DefaultButton.Config(
                    title: "Log In",
                    style: .fullyRoundedPrimary,
                    action: .simple(
                        owner.makeLogInButtonConfigAction(
                            email: email,
                            password: password
                        )
                    )
                )
            }
            .startWith(makeBaseFullyRoundedPrimaryButtonConfig("Log In"))
    }
    
    private func makeLogInButtonConfigAction(
        email: String,
        password: String
    ) -> (() -> ())? {
        guard !email.isEmpty, !password.isEmpty else { return nil }
        return { [weak self] in
            guard let self else { return }
            self.loginTrigger.onNext(())
        }
    }
    
    
    // Remember me button config
    private func makeRememberMeButtonConfig() -> Driver<DefaultButton.Config> {
        return loginIsRememberMeStorage
            .asDriverOnErrorJustComplete()
            .map { [weak self] isSelected in
                self?.setupRememberMeButtonConfig(isSelected: isSelected) ?? .empty()
            }
    }
    
    private func setupRememberMeButtonConfig(isSelected: Bool) -> DefaultButton.Config {
        return DefaultButton
            .Config(
                title: "Remember me",
                style: .chekButton(
                    isSelected: isSelected,
                    substile: .light
                ),
                action: .simple({ [weak self] in
                    guard let self else { return }
                    self.loginIsRememberMeStorage.onNext(!isSelected)
                })
            )
    }
    
    // Forgot password button config
    private func makeForgotPusswordButtonConfig() -> Driver<DefaultButton.Config> {
        Driver<DefaultButton.Config>
            .just(
                .init(
                    title: "Forgot password?",
                    style: .light,
                    action: .simple({ [weak self] in
                        guard let self else { return }
                        self.screenState.onNext(.recoveryPassword)
                    })
                )
            )
    }
    
    private func makeCreateAcountText() -> Driver<String> {
        .just("New to our platform? ")
    }
    
    private func makeAccountButtonConfig() -> Driver<DefaultButton.Config> {
        .just(
            .init(
                title: "Create an Account",
                style: .light,
                action: .simple({ [weak self] in
                    guard let self else { return }
                    self.screenState.onNext(.signUp)
                })
            )
        )
    }
    
    private func getKeyboardHeight() -> Driver<CGFloat> {
        keyboardUseCase
            .getKeyboardHeight()
            .asDriverOnErrorJustComplete()
    }
    
    // MARK: - Login
    
    private func subscribeOnLogin() {
        loginTrigger
            .asDriverOnErrorJustComplete()
            .withLatestFrom(loginFieldsText)
            .flatMapLatest(
                weak: self,
                selector: { owner, loginData in
                    owner
                        .login(
                            email: loginData.0,
                            password: loginData.1
                        )
                }
            )
            .flatMapLatest(weak: self) { owner, _ in
                owner.loginStateUseCase
                    .login()
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    // Try login
    private func login(
        email: String,
        password: String
    ) -> Driver<Void> {
        return loginUseCase
            .login(
                email: email,
                password: password
            )
            .trackActivity(activityTracker)
            .trackError(loginErrorTracker)
            .asDriverOnErrorJustComplete()
    }
    
}

// MARK: - Password recovery state methods

extension AuthenticationViewModel {
    
    private func makePasswordRecoveryInput() -> Driver<PasswordRecoveryView.Input> {
        .just(
            .init(
                emailTxtFieldConfigs: makeEmailPasswordRecoveryConfig(),
                recoverButtonConfig: makeRecoveryButtonConfig(),
                signInClickableLabelConfig: makeToSignInClickableLabelConfig()
            )
        )
    }
    
    private func makeEmailPasswordRecoveryConfig() -> Driver<TitledTextField.Config> {
        .just(
            .init(
                title: "Email Address",
                config: .init(
                    style: .bordered,
                    textObserver: { [weak self] text in
                        guard let self else { return }
                        self.passwordRecoveryEmail.onNext(text)
                    }
                )
            )
        )
    }
    
    private func makeRecoveryButtonConfig() -> Driver<DefaultButton.Config> {
        passwordRecoveryEmail
            .withUnretained(self)
            .map({ owner, email in
                return .init(
                    title: "Recover Password",
                    style: .fullyRoundedPrimary,
                    action: .simple(owner.makeRecoveryButtonConfigAction(email: email))
                )
            })
            .startWith(makeBaseFullyRoundedPrimaryButtonConfig("Recover Password"))
            .asDriverOnErrorJustComplete()
    }
    
    private func makeToSignInClickableLabelConfig() -> Driver<ClickableLabel.Config> {
        .just(
            .init(
                fullText: "Return to Sign in",
                clickableText: "Sign in",
                action: { [weak self] in
                    guard let self else { return }
                    self.screenState.onNext(.login)
                }
            )
        )
    }
    
    private func makeRecoveryButtonConfigAction(email: String) -> (() -> ())? {
        guard !email.isEmpty else { return nil }
        return { [weak self] in
            guard let self else { return }
            self.resetPasswordTrigger.onNext(())
        }
    }
    
    private func subscribeOnResetPassword() {
        resetPasswordTrigger
            .asDriverOnErrorJustComplete()
            .withLatestFrom(passwordRecoveryEmail.asDriverOnErrorJustComplete())
            .flatMapLatest(weak: self) { owner, email in
                owner.resetPasswordUseCase
                    .resetPassword(.init(email: email))
                    .trackActivity(owner.activityTracker)
                    .trackComplete(
                        owner.loginErrorTracker,
                        message: "An email has been sent to you."
                    )
                    .trackError(owner.loginErrorTracker)
                    .asDriverOnErrorJustComplete()
            }
        // When all ok, go to the next screen
            .do(self) { owner, _ in
                owner.screenState.onNext(.recoveryPasswordResult)
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: -  Password recovery result state methods

extension AuthenticationViewModel {
    
    private func makePasswordRecoveryResultInput() -> Driver<PasswordRecoveryResultView.Input> {
        .just(.init(signInButtonConfig: makeReturnToSignInButtonConfig()))
    }
    
    private func makeReturnToSignInButtonConfig() -> Driver<DefaultButton.Config> {
        .just(
            .init(
                title: "Return to Sign in",
                style: .fullyRoundedPrimary,
                action: .simple({ [weak self] in
                    guard let self else { return }
                    self.screenState.onNext(.login)
                })
            )
        )
    }
}

// MARK: -  Sign up state methods

extension AuthenticationViewModel {
    
    private func makeSignUpInput() -> Driver<SignUpView.Input> {
        .just(
            .init(
                signUpTxtFieldConfigs: makeSignUpTxtFieldConfigs(),
                agreeButtonConfig: makeSignUpAgreeButtonConfig(),
                termConditionsButtonConfig: makeSignUpTermsConditionsButtonConfig(),
                signUpButtonConfig: makeSignUpButtonConfig(),
                signInClickableLabelConfig: makeUpSignInClickableLabelConfig()
            )
        )
    }
    
    private func makeSignUpTxtFieldConfigs() -> Driver<[TitledTextField.Config]> {
        .just(
            [
                .init(
                    title: "First Name",
                    config: .init(
                        style: .bordered,
                        textObserver: { [weak self] text in
                            guard let self else { return }
                            self.signUpFirstName.onNext(text)
                        }
                    )
                ),
                .init(
                    title: "Last Name",
                    config: .init(
                        style: .bordered,
                        textObserver: { [weak self] text in
                            guard let self else { return }
                            self.signUpLastName.onNext(text)
                        }
                    )
                ),
                .init(
                    title: "Email Address",
                    config: .init(
                        style: .bordered,
                        textObserver: { [weak self] text in
                            guard let self else { return }
                            self.signUpEmail.onNext(text)
                        }
                    )
                ),
                .init(
                    title: "Password",
                    config: .init(
                        style: .bordered,
                        textObserver: { [weak self] text in
                            guard let self else { return }
                            self.signUpPassword.onNext(text)
                        }
                    )
                ),
                .init(
                    title: "Confirm Password",
                    config: .init(
                        style: .bordered,
                        textObserver: { [weak self] text in
                            guard let self else { return }
                            self.signUpConfirmPassword.onNext(text)
                        }
                    )
                )
            ]
        )
    }
    
    private func makeSignUpAgreeButtonConfig() -> Driver<DefaultButton.Config> {
        signUpIsAgreeStorage
            .asDriverOnErrorJustComplete()
            .map { [weak self] isSelected in
                guard let self else { return .empty() }
                return self.setupSignUpAgreeButtonConig(isSelected)
            }
        
    }
    
    private func setupSignUpAgreeButtonConig(_ isSelected: Bool) -> DefaultButton.Config {
        return DefaultButton
            .Config(
                title: "I agree to the",
                style: .chekButton(
                    isSelected: isSelected,
                    substile: .light
                ),
                action: .simple({ [weak self] in
                    guard let self else { return }
                    self.signUpIsAgreeStorage.onNext(!isSelected)
                })
            )
    }
    
    private func makeSignUpTermsConditionsButtonConfig() -> Driver<DefaultButton.Config> {
        .just(
            .init(
                title: "terms & conditions",
                style: .light,
                action: .simple({
                    
                })
            )
        )
    }
    
    private func makeSignUpButtonConfig() -> Driver<DefaultButton.Config> {
        Driver
            .combineLatest(
                signUpFieldsText,
                signUpIsAgreeStorage.asDriverOnErrorJustComplete()
            )
            .map(self) { (owner, arg1) in
                let ((txtTextFields), isAgree) = arg1
                return DefaultButton.Config
                    .init(
                        title: "Sign Up",
                        style: .fullyRoundedPrimary,
                        action: .simple(
                            owner.makeSignUpButtonConfigAction(
                                firstName: txtTextFields.0,
                                lastName: txtTextFields.1,
                                email: txtTextFields.2,
                                password: txtTextFields.3,
                                confirmedPassword: txtTextFields.4,
                                isAgree: isAgree
                            )
                        )
                    )
            }
            .startWith(makeBaseFullyRoundedPrimaryButtonConfig("Sign Up"))
        
    }
    
    private func makeUpSignInClickableLabelConfig() -> Driver<ClickableLabel.Config> {
        .just(
            .init(
                fullText: "Already have an account? Log in",
                clickableText: "Log in",
                action: { [weak self] in
                    guard let self else { return }
                    self.screenState.onNext(.login)
                }
            )
        )
    }
    
    private func makeSignUpButtonConfigAction(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        confirmedPassword: String,
        isAgree: Bool
    ) -> (() -> ())? {
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty,
              !confirmedPassword.isEmpty,
              isAgree,
              password == confirmedPassword
        else { return nil }
        return { [weak self] in
            guard let self else { return }
            self.navigator.toSubscription()
        }
    }
    
}

// MARK: - Screen state

extension AuthenticationViewModel {
    enum ScreenState {
        case login
        case recoveryPassword
        case recoveryPasswordResult
        case signUp
        
        fileprivate var titleText: String {
            switch self {
            case .login:
                return "Log in to SKUific App"
                
            case .recoveryPassword, .recoveryPasswordResult:
                return "Forgotten Your Password?"
                
            case .signUp:
                return "Sign up to SKUify"
            }
        }
        
        fileprivate var subtitleText: String {
            switch self {
            case .login, .signUp:
                return ""
                
            case .recoveryPassword:
                return "Don’t worry, we’ll send you a message to help you reset your password."
                
            case .recoveryPasswordResult:
                return "We’ve sent you an email to help you reset your password. Remember to check your spam inbox if you can’t find it."
            }
        }
    }
    
}

// MARK: - Input Output

extension AuthenticationViewModel {
    struct Input { }
    
    struct Output {
        let keyboardHeight: Driver<CGFloat>
        // Binding to tiltes
        let titleLabelText: Driver<String>
        let subtitleLabelText: Driver<String>
        // Changing the displayed view
        let toLogin: Driver<Void>
        let toRecoveryPassword: Driver<Void>
        let toRecoveryPasswordResult: Driver<Void>
        let toSignUp: Driver<Void>
        // Binding to mutable views
        let loginInput: Driver<LoginView.Input>
        let passwordRecoveryInput: Driver<PasswordRecoveryView.Input>
        let passwordRecoveryResultInput: Driver<PasswordRecoveryResultView.Input>
        let signUpInput: Driver<SignUpView.Input>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>

    }
    
}
