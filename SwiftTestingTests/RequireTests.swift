//
//  RequireTests.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-02-27.
//

import Testing
@testable import SwiftTesting

@Suite struct RequireTests {
    
    // Insist to failure to demonstrate the multiple #expect failing
    // Run all the lines within this function even the #expect conditon doesn't meet
    @Test
    func multipleExpect() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(3, 5)
        #expect(result == 7, "Expected 3 + 5 to equal 7")
        
        let result2 = mathOperations.add(1, 2)
        #expect(result2 == 4, "Expected 1 + 2 to equal 4")
    }
    
    // Insist to failure to demonstrate the it stopped at #require
    // Expected to stop running the remaining lines if #require condition doesn't meet
    @Test
    func stopAtRequire() throws {
        let mathOperations = MathOperations()
        let result = mathOperations.add(3, 5)
        let _ = try #require(result == 7, "Expected 3 + 5 to equal 7")
        
        // stopped at the line above as it declares the test as #require
        let result2 = mathOperations.add(1, 2)
        #expect(result2 == 4, "Expected 1 + 2 to equal 4")
    }
}

