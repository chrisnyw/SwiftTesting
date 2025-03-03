//
//  TagsTests.swift
//  SwiftTesting
//
//  Created by Chris Ng on 2025-02-27.
//

import Testing
@testable import SwiftTesting


// https://developer.apple.com/documentation/testing/addingtags
extension Tag {
  @Tag static var subtraction: Self
}

extension Tag {
  enum com_chris_swiftTesting {}
}


extension Tag.com_chris_swiftTesting {
  @Tag static var extraSpecial: Tag
}


@Suite struct TagsTests {

    @Test
    func addition() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
    
    @Test(.tags(Tag.subtraction))
    func subtraction() {
        let mathOperations = MathOperations()
        let result = mathOperations.subtract(10, 3)
        #expect(result == 7, "Expected 10 - 3 to equal 7")
    }
}
