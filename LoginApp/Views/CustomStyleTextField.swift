//
//  CustomStyleTextField.swift
//

import UIKit

class CustomStyleTextField: UITextField {
    
    private var radius: CGFloat = 8
    
    override var placeholder: String? {
        didSet {
            if let string = placeholder {
                self.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: AppConfig.subTextColor])
            }
        }
    }
    
    lazy var shadow: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = self.bounds
        layer.backgroundColor = AppConfig.backgroundColor.cgColor
        layer.shadowColor = AppConfig.darkShadow
        layer.shadowOffset = CGSize(width: -10, height: 10)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10
        layer.cornerRadius = self.frame.size.height/radius
        return layer
    }()
    
    lazy var bottomBorder: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: self.frame.size.height-1, width: frame.size.width, height: 1)
        layer.backgroundColor = AppConfig.darkShadow
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.returnKeyType = UIReturnKeyType.done
        self.backgroundColor = AppConfig.backgroundColor
        self.textColor = AppConfig.textColor
        self.tintColor = AppConfig.tintColor
        
        self.bottomBorder.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.height/radius
        self.layer.insertSublayer(bottomBorder, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setViewStyle()
    }
    
    private func setViewStyle() {
        let offset: CGFloat = 18
        bottomBorder.bounds = self.layer.bounds
        bottomBorder.frame = CGRect(x: 0, y: bounds.size.height - font!.lineHeight + offset, width: bounds.size.width, height: 1)
        
        if isValidText(self.text!) {
            bottomBorder.backgroundColor = UIColor.green.cgColor
        }
        else {
            bottomBorder.backgroundColor = AppConfig.darkShadow
        }
        
    }

    private func isValidText(_ text: String?) -> Bool {
        guard let text = text else { return false }
        return text.count > 3
    }
}


/*
 shadow.frame = bounds
 shadow.masksToBounds = false
 
 bottomBorder.removeFromSuperlayer()
 layer.insertSublayer(shadow, at: 0)
 
 //
 
 shadow.removeFromSuperlayer()
 */
