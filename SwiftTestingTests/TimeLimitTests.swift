//
//  TimeLimitTests.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-02-27.
//

import Testing

// https://developer.apple.com/documentation/testing/limitingexecutiontime
@Suite struct TimeLimitTests {
    
    @Test("Time limit test", .timeLimit(.minutes(1)))
    func withinTimeLimit() async throws {
        try await Task.sleep(until: .now + .seconds(2))
    }
    
    // Insist to fail the test to demonstrate exceed time limit
    // Unit test fail due to exceed the expected time
    @Test("Expected Time Limit Error", .timeLimit(.minutes(1)))
    func exceededTimeLimit() async throws {
        try await Task.sleep(until: .now + .seconds(65))
    }
    
}
