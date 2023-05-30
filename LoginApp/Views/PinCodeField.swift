//
//  PinCodeTextField.swift
//

import UIKit

class PinCodeField: UIView {
    
    var pinCode: String {
        get {
            var code: String = ""
            for pin_field in self.pinCodeStackView.arrangedSubviews {
                if let pin = pin_field as? NeumorphicTextField {
                    code += pin.text ?? ""
                }
            }
            return code
        }
    }
    
    var pinCodeLength: Int = 4 {
        didSet {
            self.setupView()
            self.setNeedsDisplay()
        }
    }
    
    private var spacing: CGFloat = 20
    
    private lazy var pinCodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override var canBecomeFirstResponder: Bool { return true }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        self.addSubview(pinCodeStackView)
    }
    
    private func setupView() {
        //pinCodeStackView.removeAllArrangedSubviews()
        for view in pinCodeStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for cons in constraints {
            if cons.firstAttribute == .width { cons.isActive = false }
        }
        
        layoutIfNeeded()
        
        for tag in 1...pinCodeLength {
            let textField = NeumorphicTextField()
            textField.tag = tag
            textField.delegate = self
            textField.textAlignment = .center
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            pinCodeStackView.addArrangedSubview(textField)
        }
        
        pinCodeStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pinCodeStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pinCodeStackView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: CGFloat(0.9)).isActive = true
        pinCodeStackView.widthAnchor.constraint(equalTo: pinCodeStackView.heightAnchor, multiplier: CGFloat(pinCodeLength), constant: CGFloat(pinCodeLength - 1) * spacing).isActive = true
        
        for pin_field in pinCodeStackView.arrangedSubviews {
            guard let pin = pin_field as? NeumorphicTextField else { return }
            if pin.tag == 1 { pin.becomeFirstResponder() }
            
            pinCodeStackView.addConstraints([
                pin.heightAnchor.constraint(equalTo: pinCodeStackView.heightAnchor),
                pin.widthAnchor.constraint(equalTo: pinCodeStackView.heightAnchor)
                ])
        }
    }
}

extension PinCodeField: PinTextFieldDelegate {
    func didPressBackspace(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if (text.isEmpty) {
            if let prevTextField = textField.superview?.viewWithTag(textField.tag - 1) as? UITextField {
                textField.resignFirstResponder()
                prevTextField.becomeFirstResponder()
                prevTextField.text = ""
            }
        }
    }
}

extension PinCodeField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        let currentText = textField.text!
        
        if currentText.count + string.count - range.length > 1 { return false }
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits) == nil { return false }
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        textField.text = newText
        
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        } else {
            //textField.resignFirstResponder()
            
        }
        
        return false
    }
}
