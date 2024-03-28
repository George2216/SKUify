//
//  NoteRequestModel.swift
//  Domain
//
//  Created by George Churikov on 27.03.2024.
//

import Foundation

public struct NoteRequestModel {
    public let id: Int
    public let note: String
    
    public init(
        id: Int,
        note: String
    ) {
        self.id = id
        self.note = note
    }
    
}
