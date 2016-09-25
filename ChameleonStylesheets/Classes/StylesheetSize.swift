//
//  StylesheetSize.swift
//  Pods
//
//  Created by Andreas on 25.09.16.
//
//

import UIKit

// MARK: Size validation

internal extension String {
    var isSizeValue: Bool {
        guard let floatValue = Float(self), floatValue > 0.0 else {
            return false
        }
        
        return true
    }
}
