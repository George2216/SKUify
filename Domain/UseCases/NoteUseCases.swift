//
//  NoteInventoryUseCase.swift
//  Domain
//
//  Created by George Churikov on 27.03.2024.
//

import Foundation
import RxSwift

public protocol NoteInventoryUseCase {
    func updateNote(_ note: String?) -> Observable<Void>
}
