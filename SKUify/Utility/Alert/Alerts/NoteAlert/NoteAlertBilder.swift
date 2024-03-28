//
//  NoteAlertBilder.swift
//  SKUify
//
//  Created by George Churikov on 26.03.2024.
//

import Foundation
import UIKit

final class NoteAlertBilder {
    static func instatiate(
        _ input: NoteAlertView.Input,
        di: DIProtocol
    ) -> UIViewController {
        let viewModel = NoteAlertViewModel(useCases: di)
        let vc = NoteAlertVC(input)
        vc.viewModel = viewModel
        return vc
    }
    
}
