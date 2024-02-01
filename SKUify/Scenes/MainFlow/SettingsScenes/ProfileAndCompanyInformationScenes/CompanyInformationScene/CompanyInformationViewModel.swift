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

    private let userDataRequestStorage = BehaviorSubject<CompanyInformationRequestModel?>(value: nil)
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
    }
    
    override func transform(_ input: Input) -> Output {
        _ = super.transform(input)
        return Output(
            keyboardHeight: getKeyboardHeight(),
            contentData: contentDataStorage.compactMap({ $0 }).asDriverOnErrorJustComplete(),
            tapOnUploadImage: .empty(),
            fetching: .empty(),
            error: .empty()
        )
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
                    userDataRequestStorage.asDriverOnErrorJustComplete()
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
                        companyAvatarImage: data.companyAvatarImage,
                        companyName: data.companyName,
                        companyEmail: data.companyEmail,
                        companyWebsite: data.companyWebsite ,
                        addressOne: data.addressOne,
                        addressTwo: data.addressTwo,
                        postCode: data.postCode,
                        city: data.city
                    )
                )
                owner.userDataRequestStorage.onNext(dataStorage)
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
                                    //                                    self.tapOnSelectImage.onNext(())
                                }
                            )
                        ),
                        removeButtonConfig: .init(
                            title: "Remove",
                            style: .simple,
                            action: { [weak self] in
                                guard let self else { return }
                                //                                self.tapOnRemoveImage.onNext(())
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
                                    //                                    self.changeFirstName.onNext(text)
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
                                    //                                    self.changeLastName.onNext(text)
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
                                    //                                    self.changeEmail.onNext(text)
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
                                    //                                    self.changePhone.onNext(text)
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
                                    //                                    self.changePhone.onNext(text)
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
                                    //                                    self.changePhone.onNext(text)
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
                                    //                                    self.changePhone.onNext(text)
                                }
                            )
                        ),
                        .init(
                            title: "Country",
                            config: .init(
                                style: .bordered,
                                text: user.city ?? "",
                                textObserver: { [weak self] text in
                                    guard let self else { return }
                                    //                                    self.changePhone.onNext(text)
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
                                // self.tapOnSave.onNext(())
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



