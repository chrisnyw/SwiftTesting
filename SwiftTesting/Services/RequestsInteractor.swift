//
//  RequestsInteractor.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-03-03.
//

import Combine

protocol RequestsInteractor {
    func asyncRequest() async throws -> [String]
}

class RealRequestsInteractor: RequestsInteractor {
    private let requestsDataStore: RequestsDataStore
    
    init(requestsDataStore: RequestsDataStore) {
        self.requestsDataStore = requestsDataStore
    }
    
    func asyncRequest() async throws -> [String] {
        return try await self.requestsDataStore.asyncFetchData()
    }
    
    func blockRequest(_ completion: @escaping ([String]) -> Void) {
        let result = self.requestsDataStore.fetchData()
        completion(result)
    }
    
    func publisherRequest() -> AnyPublisher<[String], Never> {
        return self.requestsDataStore.dataPublisher
    }
}
