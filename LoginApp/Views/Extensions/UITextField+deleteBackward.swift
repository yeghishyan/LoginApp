//
//  UITextField+deleteBackward.swift
//

import UIKit

protocol PinTextFieldDelegate: UITextFieldDelegate {
    func didPressBackspace(_ textField: UITextField)
}

extension NeumorphicTextField {
    override func deleteBackward() {
        if let pinDelegate = self.delegate as? PinTextFieldDelegate {
            pinDelegate.didPressBackspace(self)
        }
        super.deleteBackward()
    }
}

