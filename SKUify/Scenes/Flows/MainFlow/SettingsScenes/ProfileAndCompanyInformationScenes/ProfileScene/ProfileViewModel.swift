//
//  ProfileViewModel.swift
//  SKUify
//
//  Created by George Churikov on 18.01.2024.
//

import Foundation

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class ProfileViewModel: BaseUserContentViewModel {
    private let disposeBag = DisposeBag()

    private let changeEmail = PublishSubject<String>()
    private let changeFirstName = PublishSubject<String>()
    private let changeLastName = PublishSubject<String>()
    private let changePhone = PublishSubject<String>()

    private let tapOnUploadImage = PublishSubject<Void>()
    private let tapOnRemoveImage = PublishSubject<Void>()

    private let tapOnSave = PublishSubject<Void>()
    
    private let userDataRequestStorage = BehaviorSubject<UserRequestModel?>(value: nil)
    private let contentDataStorage = BehaviorSubject<UserContentContentView.Input?>(value: nil)
    
    // Dependencies
    private let navigator: ProfileNavigatorProtocol
    
    // Use case storage
    private let userDataUseCase: Domain.UserDataUseCase
    private let userIdUseCase: Domain.UserIdUseCase
    private let keyboardUseCase: Domain.KeyboardUseCase
    
    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: ProfileUseCases,
        navigator: ProfileNavigatorProtocol
    ) {
        self.navigator = navigator
        userDataUseCase = useCases.makeUserDataUseCase()
        userIdUseCase = useCases.makeUserIdUseCase()
        keyboardUseCase = useCases.makeKeyboardUseCase()
        super.init()
        makeContentData()
        subscibers()
    }
    
    override func transform(_ input: Input) -> Output {
       _ = super.transform(input)
        subscribeToUpdateImage(input)
        
        return Output(
            navigationTitle: makeTitle(),
            keyboardHeight: getKeyboardHeight(),
            contentData: contentDataStorage.compactMap({ $0 }).asDriverOnErrorJustComplete(),
            tapOnUploadImage: tapOnUploadImage.asDriverOnErrorJustComplete(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput()
        )
    }
    
    // MARK: Subscribers
    
    private func subscibers() {
        subscribeOnSaveData()
        subscribeOnRemoveImage()
        updateEmailForUserDataRequestStorage()
        updateFirstNameForUserDataRequestStorage()
        updateLastNameForUserDataRequestStorage()
        updatePhoneForUserDataRequestStorage()
    }
    
    private func subscribeOnSaveData() {
        tapOnSave.asDriverOnErrorJustComplete()
            .withLatestFrom(userDataRequestStorage.asDriverOnErrorJustComplete())
            .compactMap({ $0 })
            .flatMapLatest(weak: self) { owner, requestData in
                return owner.saveUserData(requestData)
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func updateProfileInformation<T>(
        property: Driver<T>,
        updateClosure: @escaping(inout UserRequestModel?, T) -> Void
    ) {
        property
            .withLatestFrom(userDataRequestStorage.asDriverOnErrorJustComplete()) { value, requestDataStorage in
                return (value, requestDataStorage)
            }
            .map { value, requestDataStorage in
                var requestDataStorage = requestDataStorage
                updateClosure(&requestDataStorage, value)
                return requestDataStorage
            }
            .drive(userDataRequestStorage)
            .disposed(by: disposeBag)
    }

    private func updateEmailForUserDataRequestStorage() {
        updateProfileInformation(property: changeEmail.asDriverOnErrorJustComplete()) { requestDataStorage, email in
            requestDataStorage?.parameters?.email = email
        }
    }
    
    private func updateFirstNameForUserDataRequestStorage() {
        updateProfileInformation(property: changeFirstName.asDriverOnErrorJustComplete()) { requestDataStorage, firstName in
            requestDataStorage?.parameters?.firstName = firstName
        }
    }
    
    private func updateLastNameForUserDataRequestStorage() {
        updateProfileInformation(property: changeLastName.asDriverOnErrorJustComplete()) { requestDataStorage, lastName in
            requestDataStorage?.parameters?.lastName = lastName
        }
    }
    
    private func updatePhoneForUserDataRequestStorage() {
        updateProfileInformation(property: changePhone.asDriverOnErrorJustComplete()) { requestDataStorage, phone in
            requestDataStorage?.parameters?.phone = phone
        }
    }
    
    // MARK: - Image subscribers

    private func subscribeToUpdateImage(_ input: Input) {
        input.updateImage
            .withLatestFrom(
                Driver
                    .combineLatest(
                        userDataRequestStorage.asDriverOnErrorJustComplete(),
                        contentDataStorage.asDriverOnErrorJustComplete()
                    )
            ) { imageData, arg0 in
                return (imageData, arg0.0, arg0.1)
            }
            .do(self) { owner, arg0 in
                // Save image to request data storage
                var (imageData, requestDataStorage, _) = arg0
                requestDataStorage?.imageData = imageData
                owner.userDataRequestStorage.onNext(requestDataStorage)
            }
            .do(self) { owner, arg0 in
                // Save image to content data storage
                var (imageData, _, contentDataStorage) = arg0
                contentDataStorage?.profileHeaderViewInput.uploadInput.imageType = .fromData(imageData)
                owner.contentDataStorage.onNext(contentDataStorage)
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnRemoveImage() {
        tapOnRemoveImage.asDriverOnErrorJustComplete()
            .withLatestFrom(
                Driver.combineLatest(
                    contentDataStorage.asDriverOnErrorJustComplete(),
                    userDataRequestStorage.asDriverOnErrorJustComplete()
                )
            )
            .do(self) { owner, arg0 in
                // Remove image from content storage
                var (contentData, _) = arg0
                contentData?.profileHeaderViewInput.uploadInput.imageType = .fromURL(nil)
                owner.contentDataStorage.onNext(contentData)
            }
            .do(self) { owner, arg0 in
                // Remove image from request data storage
                var (_, contentRequestData) = arg0
                contentRequestData?.imageData = nil
                owner.userDataRequestStorage.onNext(contentRequestData)
            }
            .drive()
            .disposed(by: disposeBag)
        
    }
    
    // MARK: Make content data
    
    private func makeContentData() {
        // Get data and combined
        let combinedData = combinedUserData()
        // Save user data to request data storage
        let userData = saveUserRequestStorage(combinedData)
        // Make content view input
        let contentDataInput = makeContentDataInput(userData)
        // Save content view input to storage
        let saveContent = saveToContentDataStorage(contentDataInput)
        // Subscribe
        saveContent
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func combinedUserData() -> Driver<(UserDTO, Int, UserRequestModel?)> {
        getUserData()
            .withLatestFrom(
                Driver.combineLatest(
                    userIdUseCase.getUserId()
                        .asDriverOnErrorJustComplete(),
                    userDataRequestStorage.asDriverOnErrorJustComplete()
                )
            ) { data, arg0 in
                let (userId, dataStorage) = arg0
                return (data, userId, dataStorage)
            }
    }
    
    private func saveUserRequestStorage(
        _ combinedData: Driver<(UserDTO, Int, UserRequestModel?)>
    ) -> Driver<(ProfileViewModel, UserDTO)> {
        combinedData
            .do(self) { owner, arg0 in
                var (data, userId, dataStorage) = arg0
                // When we use empty Data() for imageData, if the remaining data is updated, the image will not change
                dataStorage = UserRequestModel(
                    parameters: .init(
                        firstName: data.firstName,
                        lastName: data.lastName,
                        email: data.email,
                        phone: data.phone
                    ),
                    userId: userId,
                    imageData: Data()
                )
                owner.userDataRequestStorage.onNext(dataStorage)
            }
            .map(self) { owner, arg0 in
                let (user, _, _) = arg0
                return (owner, user)
            }
        }
    
    private func makeContentDataInput(
        _ userData: Driver<(ProfileViewModel, UserDTO)>
    ) -> Driver<UserContentContentView.Input> {
        userData
            .map({ owner, user in
                let imageUrlText = user.avatarImage?
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                
                return .init(
                    profileHeaderViewInput: .init(
                        uploadInput: .init(
                            imageType: .fromURL(URL(string: imageUrlText)),
                            placeholderType: .person,
                            uploadButtonConfig: .init(
                                title: "Upload new picture",
                                style: .primaryPlus,
                                action: .simple({ [weak self] in
                                    guard let self else { return }
                                    self.tapOnUploadImage.onNext(())
                                })
                            )
                        ),
                        removeButtonConfig: .init(
                            title: "Remove",
                            style: .simple,
                            action: .simple({ [weak self] in
                                guard let self else { return }
                                self.tapOnRemoveImage.onNext(())
                            })
                        )
                    ),
                    fieldsConfigs: [
                        .init(
                            title: "First Name",
                            config: .init(
                                style: .bordered,
                                text: user.firstName ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeFirstName.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Last Name",
                            config: .init(
                                style: .bordered,
                                text: user.lastName ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeLastName.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Email",
                            config: .init(
                                style: .bordered,
                                text: user.email ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeEmail.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Mobile Number",
                            config: .init(
                                style: .bordered,
                                text: user.phone ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changePhone.onNext(text)
                                }
                            )
                        )
                    ],
                    saveButtonConfig: .just(
                        .init(
                            title: "Save",
                            style: .primary,
                            action: .simple({ [weak self] in
                                guard let self else { return }
                                self.tapOnSave.onNext(())
                            })
                        )
                    )
                )
            })
    }
    
    private func saveToContentDataStorage(
        _ contentDataInput: Driver<UserContentContentView.Input>
    ) -> Driver<Void> {
        contentDataInput
            .do(self) { owner, contentData in
                owner.contentDataStorage.onNext(contentData)
            }
            .map { _ in  }
    }
    
    // MARK: - Make title
    
    private func makeTitle() -> Driver<String> {
        .just("Profile")
    }
    
    // MARK: - Get keyboard height

    private func getKeyboardHeight() -> Driver<CGFloat> {
        keyboardUseCase
            .getKeyboardHeight()
            .asDriverOnErrorJustComplete()
    }
    
    // MARK: - Get user data
    
    private func getUserData() -> Driver<UserDTO> {
        userDataUseCase
            .getUserData()
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .map({ $0.user })
    }
    
    // MARK: - Save user data

    private func saveUserData(_ data: UserRequestModel) -> Driver<Void> {
        userDataUseCase.updateUserData(data: data)
            .trackActivity(activityIndicator)
            .trackComplete(errorTracker, message: "The data has been updated.")
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
        
    }
    
}

