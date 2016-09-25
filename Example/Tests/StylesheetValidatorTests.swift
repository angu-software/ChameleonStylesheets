//
//  StyleSheetValidatorValueTests.switf
//  ChameleonStylesheets
//
//  Created by Andreas on 15.09.16.
//  Copyright © 2016 DreyHomeDev. All rights reserved.
//

import UIKit
import XCTest
@testable import ChameleonStylesheets

class StylesheetValidatorTests: XCTestCase {

    fileprivate let testBundle = Bundle(for: StylesheetValidatorTests.self)
    fileprivate let stylesheetValidator = StylesheetValidator()
    
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Stylesheet
    
    func testStylesheet() {
        let simpleStylesheet = Stylesheet(withName: "simple", bundle: testBundle)
        XCTAssertNotNil(simpleStylesheet)
        XCTAssertTrue(stylesheetValidator.isValidStylesheet(simpleStylesheet!))
        
        let simpleNoRefStylesheet = Stylesheet(withName: "simple_no_ref", bundle: testBundle)
        XCTAssertNotNil(simpleNoRefStylesheet)
        XCTAssertTrue(stylesheetValidator.isValidStylesheet(simpleNoRefStylesheet!))
        
        let fontsOnlyStylesheet = Stylesheet(withName: "fonts_only", bundle: testBundle)
        XCTAssertNotNil(fontsOnlyStylesheet)
        XCTAssertTrue(stylesheetValidator.isValidStylesheet(fontsOnlyStylesheet!))
    }

    // MARK: Size
    
    func testValidSizeValue() {
        XCTAssertTrue(stylesheetValidator.isValidSize("12"))
        XCTAssertTrue(stylesheetValidator.isValidSize("sref:small"))
    }
    
    func testInvalidSizeValue() {
        XCTAssertFalse(stylesheetValidator.isValidSize("-10"))
        XCTAssertFalse(stylesheetValidator.isValidSize("abc"))
        XCTAssertFalse(stylesheetValidator.isValidSize(""))
        XCTAssertFalse(stylesheetValidator.isValidSize(" "))
        XCTAssertFalse(stylesheetValidator.isValidSize("sref:"))
        XCTAssertFalse(stylesheetValidator.isValidSize("sref: "))
        XCTAssertFalse(stylesheetValidator.isValidSize(" sref:small"))
        XCTAssertFalse(stylesheetValidator.isValidSize("cref:blue"))
        XCTAssertFalse(stylesheetValidator.isValidSize("fref:main"))
    }
    
    // MARK: Color
    
    func testValidColorValue() {
        XCTAssertTrue(stylesheetValidator.isValidColor("#ffffff"))
        XCTAssertTrue(stylesheetValidator.isValidColor("[255,255,255]"))
        XCTAssertTrue(stylesheetValidator.isValidColor("#ffffffff"))
        XCTAssertTrue(stylesheetValidator.isValidColor("[255,255,255,255]"))
        XCTAssertTrue(stylesheetValidator.isValidColor("[5,5,5,5]"))
        XCTAssertTrue(stylesheetValidator.isValidColor("[0,0,0]"))
        XCTAssertTrue(stylesheetValidator.isValidColor("[9,9,9]"))
        XCTAssertTrue(stylesheetValidator.isValidColor("[10,10,10]"))
        XCTAssertTrue(stylesheetValidator.isValidColor("[99,99,99]"))
        XCTAssertTrue(stylesheetValidator.isValidColor("[100,100,100]"))
        XCTAssertTrue(stylesheetValidator.isValidColor("[25,25,25]"))
        XCTAssertTrue(stylesheetValidator.isValidColor("cref:blue"))
    }
    
    func testInvalidColorValue() {
        XCTAssertFalse(stylesheetValidator.isValidColor(" #ffffff"))
        XCTAssertFalse(stylesheetValidator.isValidColor("#ffffff#ffffff"))
        XCTAssertFalse(stylesheetValidator.isValidColor("#ffffff "))
        XCTAssertFalse(stylesheetValidator.isValidColor("[255,255,255] "))
        XCTAssertFalse(stylesheetValidator.isValidColor("[255,255,255][255,255,255]"))
        XCTAssertFalse(stylesheetValidator.isValidColor(" [255,255,255]"))
        XCTAssertFalse(stylesheetValidator.isValidColor("#ffff"))
        XCTAssertFalse(stylesheetValidator.isValidColor("#255255255"))
        XCTAssertFalse(stylesheetValidator.isValidColor("[256,255,-1]"))
        XCTAssertFalse(stylesheetValidator.isValidColor("[256,255]"))
        XCTAssertFalse(stylesheetValidator.isValidColor("[255,255,255 ]"))
        XCTAssertFalse(stylesheetValidator.isValidColor("[,,,]"))
        XCTAssertFalse(stylesheetValidator.isValidColor(""))
        XCTAssertFalse(stylesheetValidator.isValidColor(" "))
        XCTAssertFalse(stylesheetValidator.isValidColor("cref:"))
        XCTAssertFalse(stylesheetValidator.isValidColor("cref: "))
        XCTAssertFalse(stylesheetValidator.isValidColor(" cref:blue"))
        XCTAssertFalse(stylesheetValidator.isValidColor("sref:small"))
        XCTAssertFalse(stylesheetValidator.isValidColor("fref:main"))
    }
    
    // MARK: Font
    
    func testValidFontValue() {
        XCTAssertTrue(stylesheetValidator.isValidFont(["name": "system",
                                                       "size": "11",
                                                       "color": "#ffff00"]))
        XCTAssertTrue(stylesheetValidator.isValidFont(["name": "fref:failure",
                                                       "size": "sref:medium",
                                                       "color": "cref:yellow"]))
        XCTAssertTrue(stylesheetValidator.isValidFont(["name": "fref:failure",
                                                       "size": "fref:failure",
                                                       "color": "fref:success"]))
    }
    
    func testInvalidFontValue() {
        XCTAssertFalse(stylesheetValidator.isValidFont(["name": " ",
                                                        "size": "11",
                                                        "color": "#ffff00"]))
        XCTAssertFalse(stylesheetValidator.isValidFont(["name": "",
                                                       "size": "11",
                                                       "color": "#ffff00"]))
        XCTAssertFalse(stylesheetValidator.isValidFont(["name": "sref:failure",
                                                       "size": "sref:medium",
                                                       "color": "sref:yellow"]))
        XCTAssertFalse(stylesheetValidator.isValidFont(["name": "cref:failure",
                                                       "size": "cref:failure",
                                                       "color": "cref:success"]))
    }
    
    // MARK: References
    
    func testSizeRefernce() {
        
        let simpleStylesheet = Stylesheet(withName: "simple", bundle: testBundle)
        XCTAssertNotNil(simpleStylesheet)
        
        // Sizes
        XCTAssertTrue(stylesheetValidator.isValidReference("sref:normal", inStylesheet: simpleStylesheet!))
        
        // Colors
        XCTAssertTrue(stylesheetValidator.isValidReference("cref:red", inStylesheet: simpleStylesheet!))
        XCTAssertTrue(stylesheetValidator.isValidReference("cref:green", inStylesheet: simpleStylesheet!))
        XCTAssertTrue(stylesheetValidator.isValidReference("cref:yellow", inStylesheet: simpleStylesheet!))
        
    }
}
