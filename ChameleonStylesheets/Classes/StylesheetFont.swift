//
//  StylesheetFont.swift
//  Pods
//
//  Created by Andreas on 25.09.16.
//
//

import UIKit

typealias StylesheetFont = [String: String]

enum FontAttribute: String {
    case name = "name"
    case size = "size"
    case color = "color"
}

// MARK: Font validation

internal extension Dictionary where Key: ExpressibleByStringLiteral {
    
    subscript(key: FontAttribute) -> Value? {
        get {
            guard let dictionaryKey = key.rawValue as? Key else {
                return nil
            }
            return self[dictionaryKey]
        }
        set {
            guard let dictionaryKey = key.rawValue as? Key else {
                return
            }
            self[dictionaryKey] = newValue
        }
    }
    
    /// Checks if the dictionary has a font structure.
    /// Tells if it is a font but does not tell if it is valid
    var isFont: Bool {
        return hasName && hasSize && hasColor
    }
    
    var hasName: Bool {
        return attributes.contains(FontAttribute.name.rawValue)
    }
    
    var hasSize:Bool {
        return attributes.contains(FontAttribute.size.rawValue)
    }
    
    var hasColor: Bool {
        return attributes.contains(FontAttribute.color.rawValue)
    }
}

internal extension String {
    
    var isFontName: Bool {
        let fontName = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).lowercased()
        return !self.isReference && Stylesheet.availableFontNames().map({$0.lowercased()}).contains(fontName)
    }
}
