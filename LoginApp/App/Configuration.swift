//
//  Configuration.swift
//

import UIKit

enum AppConfig {
    static let darkTheme = true
    
    //static let darkShadowColor = #colorLiteral(red: 0.03921568627, green: 0.05098039216, blue: 0.1490196078, alpha: 1)
    static let darkBackgroundColor = #colorLiteral(red: 0.1607916951, green: 0.1645008326, blue: 0.1862305403, alpha: 1) // #colorLiteral(red: 0.8549019608, green: 0.1607843137, blue: 0.4431372549, alpha: 1)
    static let lightBackgroundColor = #colorLiteral(red: 0.8823529412, green: 0.8823529412, blue: 0.9215686275, alpha: 1)
    
    static let backgroundColor = darkTheme ? darkBackgroundColor : lightBackgroundColor
    //static let textFieldColor = darkTheme ? UIColor.white : UIColor.black
    static let textColor = darkTheme ? UIColor.white : UIColor.black
    static let subTextColor = darkTheme ? UIColor.lightGray : UIColor.darkGray
    static let tintColor = darkTheme ? UIColor.lightGray : UIColor.darkGray
    static let playerItemColor = UIColor.white.withAlphaComponent(0.8)

    static let darkAlpha: CGFloat = darkTheme ? 0.6 : 0.2
    static let lightAlpha: CGFloat = darkTheme ? 0.1 : 1
    
    static let darkShadow = UIColor.black.withAlphaComponent(darkAlpha).cgColor
    static let lightShadow = UIColor.white.withAlphaComponent(lightAlpha).cgColor
    static let shadowColor = darkTheme ? lightShadow : darkShadow
}
