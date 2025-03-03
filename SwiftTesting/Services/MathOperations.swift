//
//  Test.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-02-27.
//

import Foundation

// Sample class to be tested
class MathOperations {
    enum MathError: Error {
        case divisionByZero
    }
    
    func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    func subtract(_ a: Int, _ b: Int) -> Int {
        return a - b
    }
    
    func multiply(_ a: Int, _ b: Int) -> Int {
        return a * b
    }
    
    func divide(_ a: Int, _ b: Int) throws -> Double {
        if b == 0 {
            throw MathError.divisionByZero
        }
        return Double(a) / Double(b)
    }
}
