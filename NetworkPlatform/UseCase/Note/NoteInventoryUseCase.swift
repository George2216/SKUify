//
//  NoteInventoryUseCase.swift
//  NetworkPlatform
//
//  Created by George Churikov on 27.03.2024.
//

import Foundation
import Domain
import RxSwift

final class NoteInventoryUseCase: Domain.NoteInventoryUseCase {
    
    private let network: Domain.NoteInventoryNetwork

    init(network: Domain.NoteInventoryNetwork) {
        self.network = network
    }
    
    func updateNote(_ data: NoteRequestModel) -> Observable<Void> {
        network
            .updateNote(data)
            .mapToVoid()
    }

}
