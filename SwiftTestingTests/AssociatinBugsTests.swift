//
//  AssociatinBugsTests.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-02-27.
//

import Testing
@testable import SwiftTesting

@Suite struct AssociatinBugsTests {
    
    @Test(
        "Test with bug URL",
        .bug("http://company.com/bugs/12345")
    )
    func withBugUrl() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
    @Test(
        "Test with bug URL and ID",
        .bug("http://company.com/bugs/12345", id: 12345)
    )
    func withBugUrlandID() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
    @Test(
        "Test with bug URL and ID",
        .bug("http://company.com/bugs/12345", id: "12345")
    )
    func withBugUrlandIDAsString() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
    @Test(
        "Test with bug ID",
        .bug(id: 12345)
    )
    func withBugNumber() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
    @Test(
        "Test with bug ID and title",
        .bug(id: 12345, "A bug leads to flaky tests")
    )
    func withBugComment() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
    @Test(
        "Test with bug URL, ID and title",
        .bug("http://company.com/bugs/12345", id: 12345, "A bug leads to flaky tests")
    )
    func withBugURLandIDandTitle() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
    @Test(
        "Test with bug URL, ID and title",
        .bug("http://company.com/bugs/12345", id: 12345, "A bug leads to flaky tests"),
        .bug("http://company.com/bugs/67890", id: 67890, "Another bug leads to flaky tests")
    )
    func associatedToMultipleBugs() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
}
