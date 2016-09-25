//
//  ColorValueTests.swift
//  ChameleonStylesheets
//
//  Created by Andreas on 20.09.16.
//  Copyright © 2016 DreyHomeDev. All rights reserved.
//

import XCTest
@testable import ChameleonStylesheets

class StringColorValueTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Hex color input
    
    func testUIColorHex() {
        XCTAssertEqual(UIColor.red, "#ff0000".colorValue!)
        XCTAssertEqual(UIColor.green, "#00ff00".colorValue!)
        XCTAssertEqual(UIColor.blue, "#0000ff".colorValue!)
        XCTAssertEqual(UIColor(red: 0, green: 0, blue: 1, alpha: 1), "#0000ffff".colorValue!)
    }
    
    // MARK: [red,green,blue,alpha] color input
    
    func testUIColorRGBA() {
        XCTAssertEqual(UIColor.red, "[255,0,0]".colorValue!)
        XCTAssertEqual(UIColor.green, "[0,255,0]".colorValue!)
        XCTAssertEqual(UIColor.blue, "[0,0,255]".colorValue!)
        XCTAssertEqual(UIColor(red: 0, green: 0, blue: 1, alpha: 1), "[0,0,255,255]".colorValue!)
    }
    
    func testInvalidColor() {
        XCTAssertNil("red".colorValue)
    }
}
