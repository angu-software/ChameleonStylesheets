//
//  StylesheetTests.swift
//  ChameleonStylesheets
//
//  Created by Andreas on 22.09.16.
//  Copyright © 2016 DreyHomeDev. All rights reserved.
//

import XCTest
@testable import ChameleonStylesheets

class StylesheetTests: XCTestCase {
        
    func testPrintAvailableFonts() {
        let fontNames = Stylesheet.availableFontNames()
        print("Available font names:")
        fontNames.forEach({print($0)})
        XCTAssertGreaterThan(fontNames.count, 0)
    }
}
