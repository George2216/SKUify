//
//  NoteDTO.swift
//  Domain
//
//  Created by George Churikov on 27.03.2024.
//

import Foundation

public struct NoteDTO: Codable {
    public var note: String?
    
    public init(note: String? = nil) {
        self.note = note
    }
    
}
