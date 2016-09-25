//
//  StylesheetReference.swift
//  Pods
//
//  Created by Andreas on 24.09.16.
//
//

import UIKit

enum ReferenceType: String {
    case size = "sref:"
    case color = "cref:"
    case font = "fref:"
}

struct StylesheetReference {
    var type: ReferenceType
    var parameter: String

    func value(inStylesheet stylesheet: Stylesheet) -> Any? {
        let styleSheetAttribute: String
        switch type {
            case .size:
                styleSheetAttribute = Stylesheet.Attribute.sizes
            case .color:
                styleSheetAttribute = Stylesheet.Attribute.colors
            case .font:
                styleSheetAttribute = Stylesheet.Attribute.fonts
        }
        
        return stylesheet.stylesheet?[styleSheetAttribute]?[parameter]
    }
}

extension String {
    var stylesheetReference: StylesheetReference? {
        guard self.isReference else {
            return nil
        }
        guard let index = self.characters.index(of: ":") else {
            return nil
        }
        let typeIndex = self.index(index, offsetBy: 1)
        let rawType = self.substring(to: typeIndex)
        let parameter = self.replacingOccurrences(of: rawType, with: "")
        
        guard let referenceType = ReferenceType(rawValue: rawType) else {
            return nil
        }
        
        return StylesheetReference(type: referenceType, parameter: parameter)
    }
}

// MARK: Reference validation

internal extension String {
    
    var isReference: Bool {
        return self.isReference(withType: .size) ||
            self.isReference(withType: .color) ||
            self.isReference(withType: .font)
    }
    
    func isReference(withType referenceType: ReferenceType ) -> Bool {
        let referencePrefix = referenceType.rawValue
        let refPattern = "^\(referencePrefix)\\b(\\S)+\\b$"
        return self.isMatching(pattern: refPattern)
    }
    
    var isSizeReference: Bool {
        return self.isReference(withType: .size)
    }
    
    var isColorReference: Bool {
        return self.isReference(withType: .color)
    }
    
    var isFontReference: Bool {
        return self.isReference(withType: .font)
    }
}
