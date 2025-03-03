//
//  MockRequestsDataStore.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-03-03.
//

import Testing
import Combine
@testable import SwiftTesting

final class MockRequestsDataStore: RequestsDataStore {
    var error: TestError?
    var dataResult: [String] = []
    
    var dataSubject = PassthroughSubject<[String], Never>()
    var dataPublisher: AnyPublisher<[String], Never> {
        return self.dataSubject.eraseToAnyPublisher()
    }
    
    func asyncFetchData() async throws -> [String] {
        if let error {
            throw error
        }
        
        return self.dataResult
    }
    
    func fetchData() -> [String] {
        return self.error == nil ? self.dataResult : []
    }
}

@MainActor
@Suite class RequestsInteractorTests {

    let mockDataStore: MockRequestsDataStore
    let sut: RealRequestsInteractor

    init() {
        self.mockDataStore = MockRequestsDataStore()
        self.sut = RealRequestsInteractor(requestsDataStore: self.mockDataStore)
    }
}
