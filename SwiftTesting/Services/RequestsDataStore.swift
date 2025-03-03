//
//  RequestsDataStore.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-03-03.
//

import Combine

protocol RequestsDataStore {
    var dataPublisher: AnyPublisher<[String], Never> { get }
    
    func fetchData() -> [String]
    func asyncFetchData() async throws -> [String]
}

class RealRequestsDataStore: RequestsDataStore {
    
    private var dataSubject: PassthroughSubject<[String], Never> = .init()
    var dataPublisher: AnyPublisher<[String], Never> {
        return self.dataSubject.eraseToAnyPublisher()
    }
    
    func fetchData() -> [String] {
        return []
    }
    
    func asyncFetchData() async throws -> [String] {
        return []
    }
}

