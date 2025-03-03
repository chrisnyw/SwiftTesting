//
//  SerialParallelTests.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-02-27.
//

import Testing
@testable import SwiftTesting

@Suite(.serialized) struct SerialTests {
    
    // This function will be invoked serially, once per input, because the
    // containing suite has the .serialized trait.
    @Test(arguments: 0...10)
    func addition(input: Int) {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, input)
        #expect(result == 1+input, "Expected 1 + \(input) to equal \(1+input)")
    }
    
    // This function will not run while addition(input:) is running. One test
    // must end before the other will start.
    @Test(.tags(Tag.subtraction))
    func subtraction() {
        let mathOperations = MathOperations()
        let result = mathOperations.subtract(10, 3)
        #expect(result == 7, "Expected 10 - 3 to equal 7")
    }
}

@Suite struct ParallelTests {
    
    // This function will be invoked parallely, all tests run in parallel.
    @Test(arguments: 0...10)
    func addition(input: Int) {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, input)
        #expect(result == 1+input, "Expected 1 + \(input) to equal \(1+input)")
    }
    
    // This function will be invoked parallely with addition(input:).
    @Test(.tags(Tag.subtraction))
    func subtraction() {
        let mathOperations = MathOperations()
        let result = mathOperations.subtract(10, 3)
        #expect(result == 7, "Expected 10 - 3 to equal 7")
    }
}
