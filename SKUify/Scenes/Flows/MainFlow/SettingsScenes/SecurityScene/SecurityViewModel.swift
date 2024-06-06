//
//  SecurityViewModel.swift
//  SKUify
//
//  Created by George Churikov on 05.06.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class SecurityViewModel: ViewModelProtocol {
    private let disposeBag = DisposeBag()
 
    private let updatePassword = PublishSubject<UpdaterHelperModel>()
    private let tapOnSave = PublishSubject<Void>()
    
    private let passwordsStorage = BehaviorSubject<UpdatePasswordRequestModel>(value: .empty())
        
    // Dependencies
    private let navigator: SecurityNavigatorProtocol
    
    // Use case storage
    private let keyboardUseCase: KeyboardUseCase
    private let updatePasswordUseCase: UpdatePasswordUseCase
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: SecurityUseCases,
        navigator: SecurityNavigatorProtocol
    ) {
        self.navigator = navigator
        self.keyboardUseCase = useCases.makeKeyboardUseCase()
        self.updatePasswordUseCase = useCases.makeUpdatePasswordUseCase()
        subscriptions()
    }
    
    func transform(_ input: Input) -> Output {
        return Output(
            keyboardHeight: getKeyboardHeight(),
            contentData: makeContentDataInput(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput())
    }
        
}

// MARK: - Make content data

extension SecurityViewModel {
    
    private func makeContentDataInput() -> Driver<SecurityContentView.Input> {
        .just(
            .init(
                fieldsConfig: [
                    .init(
                        title: "Old password",
                        config: .init(
                            style: .bordered,
                            textObserver: updatePassword({ data, text in
                                data.oldPassword = text
                            })
                        )
                    ),
                    .init(
                        title: "New password",
                        config: .init(
                            style: .bordered,
                            textObserver: updatePassword({ data, text in
                                data.newPassword = text
                            })
                        )
                    ),
                    .init(
                        title: "Confirm new password",
                        config: .init(
                            style: .bordered,
                            textObserver: updatePassword({ data, text in
                                data.confirmNewPassword = text
                            })
                        )
                    )
                ],
                saveButtonConfig: makeSaveButtonConfig()
            )
        )
    }
    
    private func makeSaveButtonConfig() -> Driver<DefaultButton.Config> {
        passwordsStorage.map { model in
            return .init(
                title: "Save",
                style: .primary,
                action: .simple(
                    model.isValidData ?
                    { [weak self] in
                        guard let self else { return }
                        self.tapOnSave.onNext(())
                    }
                    : nil
                )
            )
        }
        .asDriverOnErrorJustComplete()
    }
    
}

// MARK: - Subscriptions

extension SecurityViewModel {
    
    private func subscriptions() {
        subscribeOnUpdatePassvord()
        subscribeOnTapOnSave()
    }
    
    private func subscribeOnUpdatePassvord() {
        updatePassword
            .asDriverOnErrorJustComplete()
            .withLatestFrom(passwordsStorage.asDriverOnErrorJustComplete()) { updater, passwords in
                return (updater, passwords)
            }
            .map { updater, passwordsStorage in
                updater.update(passwordsStorage)
            }
            .drive(passwordsStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnTapOnSave() {
        tapOnSave
            .asDriverOnErrorJustComplete()
            .withLatestFrom(passwordsStorage.asDriverOnErrorJustComplete())
            .flatMapLatest(weak: self) { owner, data in
                owner.updatePassword(data)
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Helper methods

extension SecurityViewModel {
    
    func updatePassword<T>(
        _ update: @escaping (inout UpdatePasswordRequestModel, T) -> Void
    ) -> (T) -> Void {
        return { [weak self] value in
            self?.updatePassword.onNext(
                .init(
                    update: { data in
                        var data = data
                        update(&data, value)
                        return data
                    }
                )
            )
        }
    }
    
}

// MARK: - Helper Models

extension SecurityViewModel {
    
    struct UpdaterHelperModel {
        var update: (UpdatePasswordRequestModel) -> UpdatePasswordRequestModel
    }
    
}

// MARK: - Get keyboard height

extension SecurityViewModel {
    
    private func getKeyboardHeight() -> Driver<CGFloat> {
        keyboardUseCase
            .getKeyboardHeight()
            .asDriverOnErrorJustComplete()
    }
    
}

// MARK: - Reuests

extension SecurityViewModel {
    
    private func updatePassword(_ data: UpdatePasswordRequestModel) -> Driver<Void> {
        updatePasswordUseCase
            .updatePassword(data)
            .trackActivity(activityIndicator)
            .trackComplete(errorTracker, message: "The data has been updated.")
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
    }
    
}

// MARK: - Input Output

extension SecurityViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        // Use for scroll to textfield
        let keyboardHeight: Driver<CGFloat>
        // Scroll content
        let contentData: Driver<SecurityContentView.Input>
        // Trackers
        let fetching: Driver<Bool>
        let error: Driver<BannerView.Input>
    }
    
}
