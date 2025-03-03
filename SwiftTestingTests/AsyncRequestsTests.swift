//
//  AsyncRequestsTests.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-03-03.
//

import Testing
import Combine
@testable import SwiftTesting

final class AsyncRequestsTests: RequestsInteractorTests {
    
    // Run test with completion block
    @Test
    func verifyCompletionBlock() async {
        let mockData = ["ABC", "DEF", "GHI"]
        self.mockDataStore.dataResult = mockData
        
        await confirmation { confirm in
            self.sut.blockRequest { result in
                #expect(result == mockData)
                confirm()
            }
        }
    }
    
    // Run test with async await
    @Test
    func verifyAsync() async throws {
        let mockData = ["ABC", "DEF", "GHI"]
        self.mockDataStore.dataResult = mockData
        let result = try await self.sut.asyncRequest()
        #expect(result == mockData)
    }
    
    // Run test with publisher observation
    @Test
    func verifyPublisher() async throws {
        let mockData = ["ABC", "DEF", "GHI"]
        
        var cancellables: Set<AnyCancellable> = []
        await confirmation { confirmation in
            self.sut.publisherRequest()
                .sink(receiveValue: { value in
                    #expect(value == mockData)
                    confirmation()
                })
                .store(in: &cancellables)
            
            self.mockDataStore.dataSubject.send(mockData)
        }
    }
    
    // Run test with publisher observation with multiple output
    @Test
    func verifyPublisherWithMultipleOutput() async throws {
        let mockData = [["ABC", "DEF", "GHI"], ["123", "456", "789"]]
        var currentCount = 0
        
        var cancellables: Set<AnyCancellable> = []
        await confirmation(expectedCount: mockData.count) { confirmation in
            self.sut.publisherRequest()
                .sink(receiveValue: { value in
                    #expect(value == mockData[currentCount])
                    currentCount += 1
                    confirmation()
                })
                .store(in: &cancellables)
            
            for mockDataObject in mockData {
                self.mockDataStore.dataSubject.send(mockDataObject)
            }
        }
    }
    
}
