//
//  NoteInventoryUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 27.03.2024.
//

import Foundation
import Domain
import RxSwift

final class NoteInventoryUseCase: Domain.NoteUseCase {
    
    private let network: Domain.NoteNetwork

    init(network: Domain.NoteNetwork) {
        self.network = network
    }
    
    func updateNote(_ data: NoteRequestModel) -> Observable<Void> {
        network
            .updateNote(data)
            .mapToVoid()
    }

}
