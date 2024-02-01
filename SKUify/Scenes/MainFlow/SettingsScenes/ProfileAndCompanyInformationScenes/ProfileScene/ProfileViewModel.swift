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

    private let tapOnSelectImage = PublishSubject<Void>()
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
            keyboardHeight: getKeyboardHeight(),
            contentData: contentDataStorage.compactMap({ $0 }).asDriverOnErrorJustComplete(),
            tapOnUploadImage: tapOnSelectImage.asDriverOnErrorJustComplete(),
            fetching: activityIndicator.asDriver(),
            error: errorTracker.asBannerInput(.error)
        )
    }
    
    // MARK: Subscribers
    
    private func subscibers() {
        subscribeOnSaveData()
        subscribeOnEmailChanged()
        subscribeOnFirstNameChanged()
        subscribeOnLastNameChanged()
        subscriveOnPhoneChaged()
        subscribeOnRemoveImage()
    }
    
    private func subscribeOnRemoveImage() {
        tapOnRemoveImage.asDriverOnErrorJustComplete()
            .withLatestFrom(
                Driver.combineLatest(
                    contentDataStorage.asDriverOnErrorJustComplete(),
                    userDataRequestStorage.asDriverOnErrorJustComplete()
                )
            )
            .withUnretained(self)
            .do(onNext: { owner, arg0 in
                // Remove image from content storage
                var (contentData, _) = arg0
                contentData?.profileHeaderViewInput.uploadInput.imageType = .fromURL(nil)
                owner.contentDataStorage.onNext(contentData)
            })
            .do(onNext: { owner, arg0 in
                // Remove image from request data storage
                var (_, contentRequestData) = arg0
                contentRequestData?.imageData = nil
                owner.userDataRequestStorage.onNext(contentRequestData)
            })
            .drive()
            .disposed(by: disposeBag)
        
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
    
    private func subscribeOnEmailChanged() {
        changeEmail
            .asDriverOnErrorJustComplete()
            .withLatestFrom(userDataRequestStorage.asDriverOnErrorJustComplete()) { email, requestDataStorage in
                return (email, requestDataStorage)
            }
            .map { email, requestDataStorage in
                var requestDataStorage = requestDataStorage
                requestDataStorage?.parameters?.email = email
                return requestDataStorage
            }
            .drive(userDataRequestStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnFirstNameChanged() {
        changeFirstName.asDriverOnErrorJustComplete()
            .withLatestFrom(userDataRequestStorage.asDriverOnErrorJustComplete()) { firstName, requestDataStorage in
                return (firstName, requestDataStorage)
            }
            .map { firstName, requestDataStorage in
                var requestDataStorage = requestDataStorage
                requestDataStorage?.parameters?.firstName = firstName
                return requestDataStorage
            }
            .drive(userDataRequestStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscribeOnLastNameChanged() {
        changeLastName.asDriverOnErrorJustComplete()
            .withLatestFrom(userDataRequestStorage.asDriverOnErrorJustComplete()) { lastName, requestDataStorage in
                return (lastName, requestDataStorage)
            }
            .map { lastName, requestDataStorage in
                var requestDataStorage = requestDataStorage
                requestDataStorage?.parameters?.lastName = lastName
                return requestDataStorage
            }
            .drive(userDataRequestStorage)
            .disposed(by: disposeBag)
    }
    
    private func subscriveOnPhoneChaged() {
        changePhone.asDriverOnErrorJustComplete()
            .withLatestFrom(userDataRequestStorage.asDriverOnErrorJustComplete()) { phone, requestDataStorage in
                return (phone, requestDataStorage)
            }.map { phone, requestDataStorage in
                var requestDataStorage = requestDataStorage
                requestDataStorage?.parameters?.phone = phone
                return requestDataStorage
            }
            .drive(userDataRequestStorage)
            .disposed(by: disposeBag)
    }
    
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
            .withUnretained(self)
            .do(onNext: { owner, arg0 in
                // Save image to request data storage
                var (imageData, requestDataStorage, _) = arg0
                requestDataStorage?.imageData = imageData
                owner.userDataRequestStorage.onNext(requestDataStorage)
            })
            .do(onNext: { owner, arg0 in
                // Save image to content data storage
                var (imageData, _, contentDataStorage) = arg0
                contentDataStorage?.profileHeaderViewInput.uploadInput.imageType = .fromData(imageData)
                owner.contentDataStorage.onNext(contentDataStorage)
                
            })
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
            .withUnretained(self)
            .do(onNext: { owner, arg0 in
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
            })
            .map({ owner, arg0 in
                let (user, _, _) = arg0
                return (owner, user)
            })
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
                                action: { [weak self] in
                                    guard let self else { return }
                                    self.tapOnSelectImage.onNext(())
                                }
                            )
                        ),
                        removeButtonConfig: .init(
                            title: "Remove",
                            style: .simple,
                            action: { [weak self] in
                                guard let self else { return }
                                self.tapOnRemoveImage.onNext(())
                            }
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
                            action: { [weak self] in
                                guard let self else { return }
                                self.tapOnSave.onNext(())
                            }
                        )
                    )
                )
            })
    }
    
    private func saveToContentDataStorage(
        _ contentDataInput: Driver<UserContentContentView.Input>
    ) -> Driver<Void> {
        contentDataInput
            .withUnretained(self)
            .do(onNext: { owner, contentData in
                owner.contentDataStorage.onNext(contentData)
            })
            .map({ _ in () })
    }
    
    // MARK: Get keyboard height

    private func getKeyboardHeight() -> Driver<CGFloat> {
        keyboardUseCase
            .getKeyboardHeight()
            .asDriverOnErrorJustComplete()
    }
    
    // MARK: Get user data
    
    private func getUserData() -> Driver<UserDTO> {
        userDataUseCase
            .getUserData()
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .map({ $0.user })
    }
    
    // MARK: Save user data

    private func saveUserData(_ data: UserRequestModel) -> Driver<Void> {
        userDataUseCase.updateUserData(data: data)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
        
    }
    
}

