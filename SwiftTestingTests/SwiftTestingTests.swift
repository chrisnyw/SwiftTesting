//
//  SwiftTestingTests.swift
//  SwiftTestingTests
//
//  Created by Chris Ng on 2025-02-27.
//

import Testing
@testable import SwiftTesting

@Suite struct MathOperationsTests {
    
    @Test
    func addition() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(3, 5)
        #expect(result == 8, "Expected 3 + 5 to equal 8")
    }
    
    @Test("Subtraction with positive numbers", .tags(Tag.subtraction))
    func subtraction() {
        let mathOperations = MathOperations()
        let result = mathOperations.subtract(10, 3)
        #expect(result == 7, "Expected 10 - 3 to equal 7")
    }
    
    @Test
    func multiplication() {
        let mathOperations = MathOperations()
        let result = mathOperations.multiply(4, 6)
        #expect(result == 24, "Expected 4 * 6 to equal 24")
    }
    
    @Test
    func division() throws {
        let mathOperations = MathOperations()
        let result = try mathOperations.divide(10, 2)
        #expect(result == 5.0, "Expected 10 / 2 to equal 5.0")
    }
    
    @Test
    func divisionByZeroThrowsError() {
        let mathOperations = MathOperations()
        let error = MathOperations.MathError.divisionByZero
        #expect(throws: error, "Expected division by zero to throw an error") {
            try mathOperations.divide(10, 0)
        }
    }


}

