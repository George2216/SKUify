//
//  RealmUseCaseProvider.swift
//  RealmPlatform
//
//  Created by George Churikov on 16.11.2023.
//

import Foundation
import Domain
import RealmSwift
import Realm

public final class RealmUseCaseProvider: Domain.RealmUseCaseProvider {
    
    private var configuration: Realm.Configuration
    
    public init() {
        configuration = Realm.Configuration()
    }
    
    public convenience init(configuration: Realm.Configuration) {
        self.init()
        self.configuration = configuration
    }
    
    public func makeLoginStateUseCase() -> Domain.LoginStateUseCase {
        let repository = Repository<LoginState>(configuration: configuration)
        return LoginStateUseCase(repository: repository)
    }

}
