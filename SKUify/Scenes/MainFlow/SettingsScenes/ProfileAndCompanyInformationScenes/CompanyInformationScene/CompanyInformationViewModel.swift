//
//  CompanyInformationViewModel.swift
//  SKUify
//
//  Created by George Churikov on 29.01.2024.
//

import Foundation
import Domain
import RxSwift
import RxCocoa
import RxExtensions

final class CompanyInformationViewModel: BaseUserContentViewModel {
    private let disposeBag = DisposeBag()

    private let changeCompanyName = PublishSubject<String>()
    private let changeCompanyEmail = PublishSubject<String>()
    private let changeCompanyWebsite = PublishSubject<String>()
    private let changeCompanyPhone = PublishSubject<String>()
    private let changeCompanyAddressOne = PublishSubject<String>()
    private let changeCompanyAddressTwo = PublishSubject<String>()
    private let changeCity = PublishSubject<String>()
    private let changePostCode = PublishSubject<String>()
    
    
    private let tapOnUploadImage = PublishSubject<Void>()
    private let tapOnRemoveImage = PublishSubject<Void>()

    private let tapOnSave = PublishSubject<Void>()
    
    private let companyDataRequestStorage = BehaviorSubject<CompanyInformationRequestModel?>(value: nil)
    private let contentDataStorage = BehaviorSubject<UserContentContentView.Input?>(value: nil)
    
    // Dependencies
    private let navigator: CompanyInformationNavigatorProtocol
    
    // Use case storage
    private let userDataUseCase: Domain.UserDataUseCase
    private let userIdUseCase: Domain.UserIdUseCase
    private let keyboardUseCase: Domain.KeyboardUseCase

    // Trackers
    private var activityIndicator = ActivityTracker()
    private var errorTracker = ErrorTracker()
    
    init(
        useCases: CompanyInformationUseCases,
        navigator: CompanyInformationNavigatorProtocol
    ) {
        self.navigator = navigator
        self.userDataUseCase = useCases.makeUserDataUseCase()
        self.userIdUseCase = useCases.makeUserIdUseCase()
        self.keyboardUseCase = useCases.makeKeyboardUseCase()
        super.init()
        makeContentData()
        subscribers()
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
            error: errorTracker.asBannerInput(.error)
        )
    }
    
    // MARK: - Subscribers
    
    private func subscribers() {
        subscribeOnSaveData()
        subscribeOnRemoveImage()
        updateCompanyNameForRequestDataStorage()
        updateCompanyEmailForRequestDataStorage()
        updateCompanyWebsiteForRequestDataStorage()
        updateCompanyAddressOneForRequestDataStorage()
        updateCompanyAddressTwoForRequestDataStorage()
        updateCityForRequestDataStorage()
        updatePostCodeForRequestDataStorage()
        updateCompanyPhoneForRequestDataStorage()
    }
    
    private func subscribeOnSaveData() {
        tapOnSave.asDriverOnErrorJustComplete()
            .withLatestFrom(companyDataRequestStorage.asDriverOnErrorJustComplete())
            .compactMap({ $0 })
            .flatMapLatest(weak: self) { owner, requestData in
                return owner.saveCompanyData(requestData)
            }
            .drive()
            .disposed(by: disposeBag)
    }
    
    // MARK: - Update companyDataRequestStorage by changes
    
    private func updateCompanyInformation<T>(
        property: Driver<T>,
        updateClosure: @escaping (inout CompanyInformationRequestModel?, T) -> Void
    ) {
        property
            .withLatestFrom(companyDataRequestStorage.asDriverOnErrorJustComplete()) { value, requestDataStorage in
                return (value, requestDataStorage)
            }
            .map { value, requestDataStorage in
                var requestDataStorage = requestDataStorage
                updateClosure(&requestDataStorage, value)
                return requestDataStorage
            }
            .drive(companyDataRequestStorage)
            .disposed(by: disposeBag)
    }

    private func updateCompanyNameForRequestDataStorage() {
        updateCompanyInformation(property: changeCompanyName.asDriverOnErrorJustComplete()) { requestDataStorage, companyName in
            requestDataStorage?.parameters?.companyName = companyName
        }
    }
    
    private func updateCompanyEmailForRequestDataStorage() {
        updateCompanyInformation(property: changeCompanyEmail.asDriverOnErrorJustComplete()) { requestDataStorage, companyEmail in
            requestDataStorage?.parameters?.companyEmail = companyEmail
        }
    }
    
    private func updateCompanyWebsiteForRequestDataStorage() {
        updateCompanyInformation(property: changeCompanyWebsite.asDriverOnErrorJustComplete()) { requestDataStorage, companyWebsite in
            requestDataStorage?.parameters?.companyWebsite = companyWebsite
        }
    }
    
    private func updateCompanyAddressOneForRequestDataStorage() {
        updateCompanyInformation(property: changeCompanyAddressOne.asDriverOnErrorJustComplete()) { requestDataStorage, companyAddressOne in
            requestDataStorage?.parameters?.addressOne = companyAddressOne
        }
    }
    
    private func updateCompanyAddressTwoForRequestDataStorage() {
        updateCompanyInformation(property: changeCompanyAddressTwo.asDriverOnErrorJustComplete()) { requestDataStorage, companyAddressTwo in
            requestDataStorage?.parameters?.addressTwo = companyAddressTwo
        }
    }
    
    private func updateCityForRequestDataStorage() {
        updateCompanyInformation(property: changeCity.asDriverOnErrorJustComplete()) { requestDataStorage, city in
            requestDataStorage?.parameters?.city = city
        }
    }
    
    private func updatePostCodeForRequestDataStorage() {
        updateCompanyInformation(property: changePostCode.asDriverOnErrorJustComplete()) { requestDataStorage, postCode in
            requestDataStorage?.parameters?.postCode = postCode
        }
    }
    
    private func updateCompanyPhoneForRequestDataStorage() {
        updateCompanyInformation(property: changeCompanyPhone.asDriverOnErrorJustComplete()) { requestDataStorage, companyPhone in
            requestDataStorage?.parameters?.companyPhone = companyPhone
        }
    }

    // MARK: - Image subscribers
    
    private func subscribeToUpdateImage(_ input: Input) {
        input.updateImage
            .withLatestFrom(
                Driver
                    .combineLatest(
                        companyDataRequestStorage.asDriverOnErrorJustComplete(),
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
                owner.companyDataRequestStorage.onNext(requestDataStorage)
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
    
    private func subscribeOnRemoveImage() {
        tapOnRemoveImage.asDriverOnErrorJustComplete()
            .withLatestFrom(
                Driver.combineLatest(
                    contentDataStorage.asDriverOnErrorJustComplete(),
                    companyDataRequestStorage.asDriverOnErrorJustComplete()
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
                owner.companyDataRequestStorage.onNext(contentRequestData)
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
    
    private func combinedUserData() -> Driver<(UserDTO, Int, CompanyInformationRequestModel?)> {
        getUserData()
            .withLatestFrom(
                Driver.combineLatest(
                    userIdUseCase.getUserId()
                        .asDriverOnErrorJustComplete(),
                    companyDataRequestStorage.asDriverOnErrorJustComplete()
                )
            ) { data, arg0 in
                let (userId, dataStorage) = arg0
                return (data, userId, dataStorage)
            }
    }
    
    private func saveUserRequestStorage(
        _ combinedData: Driver<(UserDTO, Int, CompanyInformationRequestModel?)>
    ) -> Driver<(CompanyInformationViewModel, UserDTO)> {
        combinedData
            .withUnretained(self)
            .do(onNext: { owner, arg0 in
                var (data, userId, dataStorage) = arg0
                // When we use empty Data() for companyAvatarImage, if the remaining data is updated, the image will not change
                dataStorage = CompanyInformationRequestModel(
                    userId: userId,
                    imageData: Data(),
                    parameters: .init(
                        companyName: data.companyName,
                        companyEmail: data.companyEmail,
                        companyWebsite: data.companyWebsite ,
                        addressOne: data.addressOne,
                        addressTwo: data.addressTwo,
                        postCode: data.postCode,
                        city: data.city
                    )
                )
                owner.companyDataRequestStorage.onNext(dataStorage)
            })
            .map({ owner, arg0 in
                let (user, _, _) = arg0
                return (owner, user)
            })
        }
    
    private func makeContentDataInput(
        _ userData: Driver<(CompanyInformationViewModel, UserDTO)>
    ) -> Driver<UserContentContentView.Input> {
        userData
            .map({ owner, user in
                let imageUrlText = user.companyAvatarImage?
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                
                return .init(
                    profileHeaderViewInput: .init(
                        uploadInput: .init(
                            imageType: .fromURL(URL(string: imageUrlText)),
                            placeholderType: .person,
                            uploadButtonConfig: .init(
                                title: "Upload Company picture",
                                style: .primaryPlus,
                                action: { [weak self] in
                                    guard let self else { return }
                                    self.tapOnUploadImage.onNext(())
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
                            title: "Company Name",
                            config: .init(
                                style: .bordered,
                                text: user.companyName ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeCompanyName.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Company Email",
                            config: .init(
                                style: .bordered,
                                text: user.companyEmail ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeCompanyEmail.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Website",
                            config: .init(
                                style: .bordered,
                                text: user.companyWebsite ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeCompanyWebsite.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Address Line 1",
                            config: .init(
                                style: .bordered,
                                text: user.addressOne ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeCompanyAddressOne.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Address Line 2",
                            config: .init(
                                style: .bordered,
                                text: user.addressTwo ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeCompanyAddressTwo.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Town/City",
                            config: .init(
                                style: .bordered,
                                text: user.city ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeCity.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Post/Zip Code",
                            config: .init(
                                style: .bordered,
                                text: user.postCode ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changePostCode.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Company phone",
                            config: .init(
                                style: .bordered,
                                text: user.companyPhone ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    self.changeCompanyPhone.onNext(text)
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
    
    // MARK: - Make title
    
    private func makeTitle() -> Driver<String> {
        .just("Company information")
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
    
    // MARK: Save company data

    private func saveCompanyData(_ data: CompanyInformationRequestModel) -> Driver<Void> {
        userDataUseCase.updateCompanyInformation(data: data)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
    }
    
}



