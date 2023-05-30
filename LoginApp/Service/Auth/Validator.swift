//
//  Validator.swift
//

import Foundation

final class Validator {
    init(minLength: UInt = 8, uppercase: Bool = false, lowercase: Bool = false, decimal: Bool = false) {
        self.minLengthR = minLength
        self.uppercaseR = uppercase
        self.lowercaseR = lowercase
        self.decimalR = decimal
    }
    
    private var uppercaseR: Bool = false
    private var lowercaseR: Bool = false
    private var decimalR: Bool = false
    private var minLengthR: UInt = 8
    
    private func uppercaseRequired(_ string: String) -> String? {
        guard string.range(of: ".*[A-Z]+.*", options: .regularExpression) != nil else { return "Must contain at least one uppercase letter." }
        return nil
    }
    
    private func lowercaseRequired(_ string: String) -> String? {
        guard string.range(of: ".*[a-z]+.*", options: .regularExpression) != nil else { return "Must contain at least one lowercase letter." }
        return nil
    }
    
    private func decimalRequired(_ string: String) -> String? {
        guard string.range(of: ".*[0-9]+.*", options: .regularExpression) != nil else { return "Must contain at least one number." }
        return nil
    }
    
    private func minimumLenght(_ string: String, length: UInt) -> String? {
        guard string.count > length else { return "Must contain at least \(length) characters." }
        return nil
    }
    
    func validate(_ string: String) -> String? {
        if uppercaseR {
            if let message = uppercaseRequired(string) { return message }
        }
        if lowercaseR {
            if let message = lowercaseRequired(string) { return message }
        }
        if decimalR {
            if let message = decimalRequired(string) { return message }
        }
        if minLengthR > 0 {
            if let message = minimumLenght(string, length: minLengthR) { return message }
        }
        return nil
    }
}
