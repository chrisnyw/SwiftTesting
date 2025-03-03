//
//  EnableDisableTests.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-02-27.
//

import Testing
@testable import SwiftTesting

// https://developer.apple.com/documentation/testing/enablinganddisabling
@Suite struct EnableDisableTests {
    enum Condition {
        case none
        case enableTest
    }
    
    static let condition: Condition = .none
    static let runAllTests: Bool = true
    
    @Test(
        "Disabled without message",
        .disabled()
    )
    func disabledWithoutMessage() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(5, 9)
        #expect(result == 14, "Expected 5 + 9 to equal 14")
    }
    
    @Test(
        "Disabled with custom Message",
        .disabled("Disabled due to pending implementation")
    )
    func disabledWithCustomMessage() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(5, 9)
        #expect(result == 14, "Expected 5 + 9 to equal 14")
    }
    
    @Test(
        "Conditional enable",
        .enabled(if: EnableDisableTests.condition == .enableTest)
    )
    func conditonalEnable() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
    @Test(
        "Conditonal enable with comment",
        .enabled(if: EnableDisableTests.condition == .enableTest, "Run only when conditon set to .enableTest")
    )
    func conditonalEnableWithComment() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
    @Test(
        "Combined two enable conditions",
        .enabled(if: EnableDisableTests.condition == .enableTest),
        .enabled(if: EnableDisableTests.runAllTests == true)
    )
    func combinedEnableConditionsTest() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
}
