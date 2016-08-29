//
//  SymbolLogTests.swift
//  SymbolLogTests
//
//  Created by Ji Mun on 8/24/16.
//  Copyright © 2016 Ji Mun. All rights reserved.
//

import XCTest
@testable import SymbolLog

class SymbolLogTests: XCTestCase {
    
    // MARK: SymbolLog Tests
    
    
    // Tests to confirm that the Meal initializer returns when no name or a negative rating is provided.
    func testSymbolInitialization() {
        
        // Success case.
        let image1 = UIImage(named: "god")!
        let potentialItem = Symbol(mainKeyword: "courage", image: image1, secondaryKeywords: [String]())
        XCTAssertNotNil(potentialItem)
        
        // Failure cases.
        let noMainKeyword = Symbol(mainKeyword: "", image: image1, secondaryKeywords: [String]())
        XCTAssertNil(noMainKeyword, "Empty main keyword is invalid")
        
        //let nilImage = nil
        
        //let noImage = Symbol(mainKeyword: "picture", image: nilImage)
        //XCTAssertNil(noImage, "No image is invalid")
    }
}
