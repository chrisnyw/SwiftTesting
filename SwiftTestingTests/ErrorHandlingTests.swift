//
//  ErrorHandlingTests.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-03-03.
//

import Testing
@testable import SwiftTesting

final class ErrorHandlingTests: RequestsInteractorTests {
    
    private let dataStoreIsDown: Bool = true
    
    // Happy path
    @Test
    func fetchSuccess() async throws {
        let mockData = ["ABC", "DEF", "GHI"]
        self.mockDataStore.dataResult = mockData
        let result = try await self.sut.asyncRequest()
        #expect(result == mockData)
    }
    
    // Expect the exactly the same .dataStoreFetchFailure throw back
    @Test
    func dataStoreError() async throws {
        let mockData = ["ABC", "DEF", "GHI"]
        let expectedError = TestError.dataStoreFetchFailure
        self.mockDataStore.dataResult = mockData
        self.mockDataStore.error = expectedError
        await #expect(throws: expectedError, "Expected dataStore throw an \(expectedError) error") {
            let result = try await self.sut.asyncRequest()
            #expect(result == mockData)
        }
    }
    
    // Mark as expected failure, expects an error to be thrown and will
    // in fact fail your test if the error isn't thrown.
    @Test
    func dataStoreKnownIssue() async throws {
        let mockData = ["ABC", "DEF", "GHI"]
        let expectedError = TestError.dataStoreFetchFailure
        self.mockDataStore.dataResult = mockData
        self.mockDataStore.error = expectedError
        await withKnownIssue("Expected a throw error happens during the asyncRequest() call") {
            let result = try await self.sut.asyncRequest()
            #expect(result == mockData)
        }
    }
    
    // Tell to pass the test if no error is thrown,
    // but mark an expected failure if an error is thrown,
    // so it's a nice middle ground while you're tackling a problem.
    @Test
    func dataStoreKnownIssueIntermittent() async throws {
        let mockData = ["ABC", "DEF", "GHI"]
        let expectedError = TestError.dataStoreFetchFailure
        self.mockDataStore.dataResult = mockData
        // Uncomment the line below and rerun this test to see the difference
//        self.mockDataStore.error = expectedError
        await withKnownIssue("Mark as expected failure if catched an error, continue otherwise.", isIntermittent: true) {
            let result = try await self.sut.asyncRequest()
            #expect(result == mockData)
        }
    }
    
    // Mark as expected failure if the dataStoreIsDown and
    // the dataStore gives back the dataStoreFetchFailure.
    @Test
    func dataStoreKnownIssueWhenTheIssueIsMatching() async throws {
        let mockData = ["ABC", "DEF", "GHI"]
        let expectedError = TestError.dataStoreFetchFailure
        self.mockDataStore.dataResult = mockData
        self.mockDataStore.error = expectedError
        try await withKnownIssue("Expect a .dataStoreFetchFailure error only when dataStoreIsDown, fail this test if received other error.", {
            let result = try await self.sut.asyncRequest()
            #expect(result == mockData)
        }, when: {
            return dataStoreIsDown
        }, matching: { issue in
            return (issue.error as? TestError) == .dataStoreFetchFailure
        })
    }
    
    // Insist to fail this test for demonstration on not expected error type
    // Get the error in line withKnownIssue below as this unit test expects
    // a SomeError when calling asyncRequest() but it does not.
    @Test
    func dataStoreKnownIssueWhenTheIssueIsNotMatching() async throws {
        let mockData = ["ABC", "DEF", "GHI"]
        let expectedError = TestError.dataStoreFetchFailure
        self.mockDataStore.dataResult = mockData
        self.mockDataStore.error = expectedError
        try await withKnownIssue("Demonstrate how to fail a test when an unexpected error is received.", {
            let result = try await self.sut.asyncRequest()
            #expect(result == mockData)
        }, when: {
            return dataStoreIsDown
        }, matching: { issue in
            issue.error is SomeError
        })
    }
}
