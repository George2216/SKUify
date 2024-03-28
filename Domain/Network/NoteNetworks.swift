//
//  NoteInventoryNetwork.swift
//  Domain
//
//  Created by George Churikov on 27.03.2024.
//

import Foundation
import RxSwift

public protocol NoteInventoryNetwork {
    func updateNote(note: String?) -> Observable<NoteDTO>
}
