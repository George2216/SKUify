//
//  NoteInventoryUseCase.swift
//  Domain
//
//  Created by George Churikov on 27.03.2024.
//

import Foundation
import RxSwift

public protocol NoteUseCase {
    func updateNote(_ data: NoteRequestModel) -> Observable<Void>
}
