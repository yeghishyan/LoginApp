//
//  CustomButton.swift
//

import UIKit

class NeumorphicButton: UIButton {
    
    var radius: CGFloat = 4
    
    lazy var lightShadow: CALayer = {
        let layer = CALayer()
        layer.name = "_lightShadow"
        layer.frame = self.bounds
        layer.backgroundColor = AppConfig.backgroundColor.cgColor
        layer.shadowColor = AppConfig.lightShadow
        layer.shadowOffset = CGSize(width: -10, height: -10)
        layer.shadowOpacity = 1
        layer.shadowRadius = 10
        layer.cornerRadius = self.frame.size.height/radius
        return layer
    }()
    
    lazy var darkShadow: CALayer = {
        let layer = CALayer()
        layer.name = "_darkShadow"
        layer.frame = self.bounds
        layer.backgroundColor = AppConfig.backgroundColor.cgColor
        layer.shadowColor = AppConfig.darkShadow
        layer.shadowOffset = CGSize(width: -10, height: 10)
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10
        layer.cornerRadius = self.frame.size.height/radius
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
    
    lazy var darkInnerShadow: CALayer = {
        let layer = CALayer()
        layer.name = "_darkInnerShadow"
        layer.shadowColor = AppConfig.darkShadow
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1
        layer.shadowRadius = 3
        return layer
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setTitleColor(AppConfig.textColor, for: .normal)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addInnerShadow()
    }
    
    private func addInnerShadow() {
        if self.isHighlighted {
            darkInnerShadow.frame = bounds
            lightInnerShadow.frame = bounds
            
            let cornerRadius = self.frame.size.height/radius
            let path = UIBezierPath(roundedRect: darkInnerShadow.bounds.insetBy(dx: -3, dy: -3), cornerRadius: cornerRadius)
            let cutout = UIBezierPath(roundedRect: darkInnerShadow.bounds, cornerRadius: cornerRadius).reversing()
            path.append(cutout)
            
            darkInnerShadow.shadowPath = path.cgPath
            darkInnerShadow.masksToBounds = true
            darkInnerShadow.cornerRadius = cornerRadius
            
            lightInnerShadow.shadowPath = path.cgPath
            lightInnerShadow.masksToBounds = true
            lightInnerShadow.cornerRadius = cornerRadius
            
            darkShadow.removeFromSuperlayer()
            lightShadow.removeFromSuperlayer()
            
            layer.insertSublayer(darkInnerShadow, at: 0)
            layer.insertSublayer(lightInnerShadow, at: 0)
        }
        else {
            darkInnerShadow.removeFromSuperlayer()
            lightInnerShadow.removeFromSuperlayer()
            
            darkShadow.frame = bounds
            lightShadow.frame = bounds
            layer.insertSublayer(darkShadow, at: 0)
            layer.insertSublayer(lightShadow, at: 0)
        }
    }
    
    private func setupView() {
        //self.layer.masksToBounds = true;
        self.layer.cornerRadius = self.frame.size.height/radius
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

