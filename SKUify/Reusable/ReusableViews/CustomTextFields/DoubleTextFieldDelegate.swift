//
//  DoubleTextFieldDelegate.swift
//  SKUify
//
//  Created by George Churikov on 29.03.2024.
//

import Foundation
import UIKit

final class DoubleTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool
    {
        let countdots = (textField.text?.components(separatedBy: ".").count ?? 0) - 1
        
        if countdots > 0 && string == "."
        {
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if var text = textField.text {
            if  text.count >= 3 {
                if let index = text.firstIndex(of: ".") {
                    text.remove(at: index)
                }
                let newIndex = text.index(
                    text.startIndex,
                    offsetBy: text.count - 2
                )
                text.insert(
                    ".",
                    at: newIndex
                )
                if text.first == "." {
                    text.insert(
                        "0",
                        at: text.startIndex
                    )
                }
                if text.first == "0" && text.count > 4 {
                    text.removeFirst()
                }
            }
            textField.text = text
        } else {
            textField.text = "0.00"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text ?? "").isEmpty {
            textField.text = "0.00"
        }
    }
    
}
