//
//  CustomTextField.swift
//

import UIKit

// Adding inner shadow
// Adding limit on text
class NeumorphicTextField: UITextField {
    private var radius: CGFloat = 4
    
    override var placeholder: String? {
        didSet {
            if let string = placeholder {
                self.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: AppConfig.subTextColor])
            }
        }
    }
    
    lazy var darkInnerShadow: CALayer = {
        let layer = CALayer()
        layer.name = "_darkInnerShadow"
        layer.shadowColor = AppConfig.darkShadow
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
        return layer
    }()
    
    lazy var lightInnerShadow: CALayer = {
        let layer = CALayer()
        layer.name = "_lightInnerShadow"
        layer.shadowColor = AppConfig.lightShadow
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
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
        
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height/radius
        self.addInnerShadow()
    }
    
    private func addInnerShadow() {
        darkInnerShadow.frame = bounds
        lightInnerShadow.frame = bounds
        
        let cornerRadius = self.frame.size.height/radius
        let path = UIBezierPath(roundedRect: darkInnerShadow.bounds.insetBy(dx: -3, dy: -3), cornerRadius: cornerRadius)
        let cutout = UIBezierPath(roundedRect: darkInnerShadow.bounds, cornerRadius: cornerRadius).reversing()
        
        path.append(cutout)
        darkInnerShadow.shadowPath = path.cgPath
        darkInnerShadow.cornerRadius = cornerRadius
        darkInnerShadow.masksToBounds = true
        
        lightInnerShadow.shadowPath = path.cgPath
        lightInnerShadow.cornerRadius = cornerRadius
        lightInnerShadow.masksToBounds = true
        
        layer.addSublayer(darkInnerShadow)
        layer.addSublayer(lightInnerShadow)
    }
}
