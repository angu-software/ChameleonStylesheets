//
//  ChameleonStyleshet.swift
//  Pods
//
//  Created by Andreas on 15.09.16.
//
//

import Foundation

final class ChameleonStylesheet: NSObject {
    
    private static var stylesheet: Stylesheet?
    
    static func setStylesheet(_ stylesheet : Stylesheet) {
        ChameleonStylesheet.stylesheet = stylesheet
    }
}
