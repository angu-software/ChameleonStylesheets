//
//  Stylesheet.swift
//  Pods
//
//  Created by Andreas on 15.09.16.
//
//

import Foundation

open class Stylesheet: NSObject {
    
    let filePath: String
    
    lazy var stylesheet: [String: AnyObject]? = {
        let fileURL = URL(fileURLWithPath: self.filePath)
        guard let fileData = try? Data(contentsOf: fileURL),
            let stylesheet = try? JSONSerialization.jsonObject(with: fileData, options: []) else {
            return nil
        }
        
        return stylesheet as? [String: AnyObject]
    }()
    
    /// The version of the stylesheet
    ///
    /// Returns an empty string if the stylesheet has no valid version
    public var version: String {
        guard let styleSheetVersion = stylesheet?[Attribute.chameleonStylesheet] as? String else {
            return ""
        }
        
        return styleSheetVersion
    }
    
    public var colors: [String: String]? {
        return nil
    }
    
    public var sizes: [String: String]? {
        return nil
    }
    
    public var fonts: [String: [String: String]]? {
        return nil
    }
    
    // MARK: Initializer
    
    public convenience init?(withName name: String, bundle: Bundle = Bundle.main) {
        guard let simpleStylesheetFilePath = bundle.path(forResource: name, ofType: "stylesheet") else {
            print("[Stylesheet] Error: could not load stylesheet \(name)")
            return nil
        }
        
        self.init(filePath: simpleStylesheetFilePath)
    }
    
    public init?(filePath: String) {
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory) ||
            isDirectory.boolValue == true {
            return nil
        }
        self.filePath = filePath
        super.init()
    }
    
    // MARK: Public methods
    
    public func color(withName: String) -> UIColor? {
        return nil
    }
    
    public func size(withName: String) -> Float? {
        return nil
    }
    
    public func font(WithName fontName: String , sizeName: String? = nil, colorName: String? = nil) -> UIFont? {
        return font(WithName: fontName, size: size(withName: sizeName ?? ""), color: color(withName: colorName ?? ""))
    }
    
    public func font(WithName fontName: String , size: Float? = nil, color: UIColor? = nil) -> UIFont? {
        return nil
    }
}

extension Stylesheet {
    struct Attribute {
        static let chameleonStylesheet = "chameleon_stylesheet"
        static let sizes = "sizes"
        static let colors = "colors"
        static let fonts = "fonts"
    }
}

// MARK: - Dictionary extensions -

internal extension Dictionary where Key: ExpressibleByStringLiteral {
    subscript(key: String) -> Value? {
        get {
            guard let dictionaryKey = key as? Key else {
                return nil
            }
            return self[dictionaryKey]
        }
        set {
            guard let dictionaryKey = key as? Key else {
                return
            }
            self[dictionaryKey] = newValue
        }
    }
    
    var attributes: [String] {
        let attributes = self.flatMap({$0.key as? String})
        return attributes
    }
}


// MARK: Stylesheet validation

internal extension Dictionary where Key: ExpressibleByStringLiteral {
    
    /// Checks if the dictionary has a stylesheet structure
    /// Does no validy check of the containing values
    /// Tells if it is a stylesheet but does not tell if it is valid
    var isStylesheet: Bool {
        return hasStylesheetVersion && (hasSizes || hasColors || hasFonts)
    }
    
    var hasStylesheetVersion: Bool {
        return attributes.contains(Stylesheet.Attribute.chameleonStylesheet)
    }
    
    var hasSizes: Bool {
        return attributes.contains(Stylesheet.Attribute.sizes)
    }
    
    var hasColors: Bool {
        return attributes.contains(Stylesheet.Attribute.colors)
    }
    
    var hasFonts: Bool {
        return attributes.contains(Stylesheet.Attribute.fonts)
    }
}
