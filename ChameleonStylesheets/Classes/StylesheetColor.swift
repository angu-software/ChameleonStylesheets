//
//  StylesheetColor.swift
//  Pods
//
//  Created by Andreas on 25.09.16.
//
//

import UIKit

// MARK: - String extension -

internal extension String {
    var colorValue: UIColor? {
        if var color = UIColor(withHexValue: self) {
            return color
        }
        
        if var color = UIColor(withRGBAValue: self) {
            return color
        }
        
        return nil
    }
}

// MARK: Color components

fileprivate extension String {
    enum ColorComponent: Int {
        case red = 0
        case green = 1
        case blue = 2
        case alpha = 3
    }
    
    subscript(colorComponent: ColorComponent) -> String? {
        if colorComponent == .alpha && self.characters.count < 8 {
            return nil
        }
        let chunkSize = 2
        let redStartIndex = self.index(self.startIndex, offsetBy: colorComponent.rawValue * chunkSize)
        let redEndIndex = self.index(redStartIndex, offsetBy: chunkSize)
        return self[redStartIndex..<redEndIndex]
    }
}

// MARK: Color validation

internal extension String {
    var isColorValue: Bool {
        return self.isHexColorValue || self.isRGBAColorValue
    }
    
    var isHexColorValue: Bool {
        let colorHexRegEx = "^\\#[0-9a-zA-Z]{6,8}$"
        return self.isMatching(pattern: colorHexRegEx)
    }
    
    var isRGBAColorValue: Bool {
        let colorRGBARegEx = "^\\[([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5]),?([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])?\\]$"
        return self.isMatching(pattern: colorRGBARegEx)
    }
}

// MARK: - UIColor extension -

fileprivate extension UIColor {
    convenience init?(withHexValue hexValue: String) {
        
        guard hexValue.isHexColorValue else {
            return nil
        }
        
        // remove the '#'
        var colorValue = hexValue
        colorValue = colorValue.replacingOccurrences(of: "#", with: "")
        
        // split the string into chunks of two characters
        guard let redHexValue = colorValue[String.ColorComponent.red],
            let greenHexValue = colorValue[String.ColorComponent.green],
            let blueHexValue = colorValue[String.ColorComponent.blue],
            let alphaHexValue = colorValue.characters.count >= 8 ? colorValue[String.ColorComponent.alpha] : "ff" else {
                return nil
        }
        
        guard let redValue = UInt(redHexValue, radix: 16),
            let greenValue = UInt(greenHexValue, radix: 16),
            let blueValue = UInt(blueHexValue, radix: 16),
            let alphaValue = UInt(alphaHexValue, radix: 16) else {
                return nil
        }
        
        let red: CGFloat = CGFloat(redValue) / 255
        let green: CGFloat = CGFloat(greenValue) / 255
        let blue: CGFloat = CGFloat(blueValue) / 255
        let alpha: CGFloat = CGFloat(alphaValue) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init?(withRGBAValue rgbaValue: String) {
        
        guard rgbaValue.isRGBAColorValue else {
            return nil
        }
        
        var colorValue = rgbaValue
        colorValue = colorValue.replacingOccurrences(of: "[", with: "")
        colorValue = colorValue.replacingOccurrences(of: "]", with: "")
        let colorValueComponents = colorValue.components(separatedBy: ",")
        
        let redRGBAValue = colorValueComponents[0]
        let greenRGBAValue = colorValueComponents[1]
        let blueRGBAValue = colorValueComponents[2]
        let alphaRGBAValue = colorValueComponents.indices.contains(3) ? colorValueComponents[3] : "255"
        
        guard let redValue = UInt(redRGBAValue),
            let greenValue = UInt(greenRGBAValue),
            let blueValue = UInt(blueRGBAValue),
            let alphaValue = UInt(alphaRGBAValue) else {
                return nil
        }
        
        let red: CGFloat = CGFloat(redValue) / 255
        let green: CGFloat = CGFloat(greenValue) / 255
        let blue: CGFloat = CGFloat(blueValue) / 255
        let alpha: CGFloat = CGFloat(alphaValue) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
