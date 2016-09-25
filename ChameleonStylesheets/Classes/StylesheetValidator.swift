//
//  StylesheetValidator.swift
//  Pods
//
//  Created by Andreas on 15.09.16.
//
//

import Foundation

open class StylesheetValidator: NSObject {
    
    func isValidStylesheet(_ stylesheet: Stylesheet) -> Bool {
        guard let stylesheet = stylesheet.stylesheet, stylesheet.isStylesheet else {
            return false
        }
        
        if stylesheet.hasSizes {
            guard let sizeElements = stylesheet[Stylesheet.Attribute.sizes] as? [String: String] else {
                return false
            }
            
            for sizeElement in sizeElements {
                if !isValidSize(sizeElement.value) {
                    return false
                }
            }
        }
        
        if stylesheet.hasColors {
            guard let colorElements = stylesheet[Stylesheet.Attribute.colors] as? [String: String] else {
                return false
            }
            
            for colorElement in colorElements {
                if !isValidColor(colorElement.value) {
                    return false
                }
            }
        }
        
        if stylesheet.hasFonts {
            guard let fontElements = stylesheet[Stylesheet.Attribute.fonts] as? [String: StylesheetFont] else {
                return false
            }
            
            for fontElement in fontElements {
                if !isValidFont(fontElement.value) {
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK: Size
    
    func isValidSize(_ size: String) -> Bool {
        return size.isSizeValue || size.isSizeReference
    }
    
    // MARK: Color
    
    func isValidColor(_ color: String) -> Bool {
        return color.isColorReference || color.isColorValue
    }
    
    // MARK: Font
    
    func isValidFont(_ font: StylesheetFont) -> Bool {
        
        if !font.isFont {
            return false
        }
        
        guard let fontName = font[FontAttribute.name],
            let fontSize = font[FontAttribute.size],
            let fontColor = font[FontAttribute.color] else {
                return false
        }
        
        return isValidFontName(fontName) &&
            isValidFontSize(fontSize) &&
            isValidFontColor(fontColor)
    }
    
    func isValidFontName(_ fontName: String) -> Bool {
        return fontName.isFontName || fontName.isFontReference
    }
    
    func isValidFontSize(_ fontSize: String) -> Bool {
        return self.isValidSize(fontSize) || fontSize.isFontReference
    }
    
    func isValidFontColor(_ fontColor: String) -> Bool {
        return self.isValidColor(fontColor) || fontColor.isFontReference
    }
    
    // MARK: Reference check
    
    func isValidReference(_ reference: String,
                          inStylesheet stylesheet: Stylesheet,
                          fromFontAttribure: FontAttribute? = nil,
                          referencePath: [String] = []) -> Bool {
        guard reference.isReference else {
            return false
        }
        
        guard !referencePath.contains(reference) else {
            return false
        }
        
        guard let stylesheetReference = reference.stylesheetReference else {
            return false
        }
        
        let referenceValue = stylesheetReference.value(inStylesheet: stylesheet)
        
        if let nextReference = referenceValue as? String,
            nextReference.isReference {
            var newReferencePath = referencePath
            newReferencePath.append(reference)
            return isValidReference(nextReference,
                                    inStylesheet: stylesheet,
                                    fromFontAttribure: fromFontAttribure,
                                    referencePath: newReferencePath)
        }
        
        switch stylesheetReference.type {
        case .size:
            if let sizeValue = referenceValue as? String,
                sizeValue.isSizeValue {
                return true
            }
        case .color:
            if let colorValue = referenceValue as? String,
                colorValue.isColorValue {
                return true
            }
        case .font:
            guard let fontAttribute = fromFontAttribure,
                let fontValue = referenceValue as? StylesheetFont,
                let referncedFontValue = fontValue[fontAttribute] else {
                return false
            }
            
            if referncedFontValue.isSizeValue {
                return true
            }
            
            if referncedFontValue.isColorValue {
                return true
            }
            
            if referncedFontValue.isReference {
                var newReferencePath = referencePath
                newReferencePath.append(reference)
                return isValidReference(referncedFontValue,
                                        inStylesheet: stylesheet,
                                        fromFontAttribure: fromFontAttribure,
                                        referencePath: newReferencePath)
            }
        }
        
        return false
    }
}

// MARK: - String extensions -

// MARK: Regex

internal extension String {
    func isMatching(pattern: String) -> Bool {
        guard let regularExpression = try? NSRegularExpression(pattern: pattern, options: []) else {
            return false
        }
        let matches = regularExpression.matches(in: self,
                                                options: [],
                                                range: NSMakeRange(0, self.characters.count))
        return matches.count > 0
    }
}
