# SwiftTesting
Demonstrate a modern way to write unit test with Swift Testing framework.

## Introduction
Writing unit tests is a curisal part of the engineers daily life. Excited that an new modern Swift Testing framework is shipped in Xcode 16 to write unit tests more easier than before.

In this SwiftTesting demo app, it shows a list of sample to demonostrate how to write unit tests with the annonation supported in Swift Testing framework.

## Prerequisites
- Xcode 16 or later
- Swift 6 or later

## Benefits of Using Swift Testing Framework Over XCTest or Quick/Nimble

Swift Testing is a modern testing framework introduced in Xcode 16 that offers a more streamlined and efficient approach to testing Swift applications. Here’s why you should consider adopting it:

### 🚀 **Advantages Over XCTest**
- **Swift-Native Syntax**: Uses Swift-first syntax, reducing boilerplate and making tests more readable.
- **Improved Assertions**: Provides a more expressive way to validate test conditions without relying on `XCTAssert` prefixes.
- **Better Test Discovery**: Automatically discovers test functions without relying on method name prefixes like `test`.
- **Asynchronous Testing Support**: Built-in support for async/await, making it easier to test asynchronous code.

### ✅ **Advantages Over Quick/Nimble**
- **No Third-Party Dependencies**: Unlike Quick/Nimble, Swift Testing is built into Xcode, ensuring better compatibility and avoiding dependency issues.
- **Lightweight and Efficient**: Eliminates the need for an external testing DSL while still offering expressive assertions.
- **Seamless Integration**: Works natively with Xcode’s test runner, diagnostics, and debugging tools.
- **Standardized Syntax**: Avoids the need for custom matchers and ensures consistency across teams.

## 🎯 **Why Switch?**
- 🚫 No more XCTest boilerplate
- 🔄 Fully Swift-native, making it future-proof
- 🔥 Expressive syntax with powerful built-in assertions
- 🛠️ Better developer experience with Xcode integration
- ⚡ Optimized for performance and async testing

## 🔥 **Basic Usage**
### 🔹 `@Suite` - Defining a Test Suite
The `@Suite` annotation is used to define a collection of related test cases. It allows grouping multiple test cases together in a structured way.

```swift
@Suite struct MathOperationsTests {
    // Define multiple related test cases
}
```
#### Benifits:
- Organizes tests logically, making them more maintainable.
- Allows for better test discovery without relying on class inheritance like XCTest.
- Helps in structuring tests modularly for different features or components.
---
### 🔹 `@Test` - Defining a Test Case
The `@Test` annotation marks a function as a test case that will be executed during test runs.
```swift
@Suite struct MathOperationsTests {
    @Test
    func addition() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(3, 5)
        #expect(result == 8, "Expected 3 + 5 to equal 8")
    }
}
```
#### Benifits:
- No need to prefix method names with test, unlike XCTest.
- Works seamlessly with Swift Testing’s built-in assertion functions.
- Enables better discoverability of test cases by Xcode’s test runner.
---
## 🔥 **Expectations and Confirmations**
### 🔹 `#expect` - Validate the result
`Expect` is used to validate conditions in a test. It provides a variety of assertion methods to check values, equality, and error handling.

**Compare result directly with the `#expect()`**
```swift
        #expect(result == mockData)
```

**Use `#expect(throws:performing:)` when the expression expression should throw an error of a given type** 
```swift
        await #expect(throws: expectedError, "Expected dataStore throw an \(expectedError) error") {
            let result = try await self.sut.asyncRequest()
            #expect(result == mockData)
        }
```

**Use `#require()` to check an expectation has passed after a condition has been evaluated and throw an error if it failed.**
```swift
    @Test func fullName() throws {
        let person = Person(firstName: "Tom", lastName: "Wong")
        try #require(person != nil, "Person should be constructed successfully")
        #expect(person?.fullName == "Tom Wong")
    }
```

**Use `confirmation()` to confirm that some event occurs during the invocation of a function. Useful for testing closure and publisher sink values.**
```swift
        await confirmation { confirm in
            self.sut.blockRequest { result in
                #expect(result == mockData)
                confirm()
            }
        }
```
```swift
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
```
---
## 🔥 **Enabling and Disabling Tests**
### 🔹 Disable a test unconditionally
The `.disabled()` trait is used to exclude a test case from execution. This is useful when a test is not ready or needs to be skipped due to some bugs or known issues.

```swift
    @Test(
        "Disabled with custom Message",
        .disabled("Disabled due to pending implementation")
    )
    func disabledWithCustomMessage() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(5, 9)
        #expect(result == 14, "Expected 5 + 9 to equal 14")
    }
```
#### Benifits
- Avoids removing tests manually while debugging.
- Allows adding a reason for skipping the test.
- Helps in managing flaky or work-in-progress tests.
---
### 🔹 Enable or disable a test conditionally
Add `.enabled(if:)` trait to `@Test` in order to run a test only when a certain condition is met.

**Enable and run this test only when condition is .enableTest**
```swift
    @Test(
        "Conditional enable",
        .enabled(if: EnableDisableTests.condition == .enableTest)
    )
    func conditonalEnable() {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, 2)
        #expect(result == 3, "Expected 1 + 2 to equal 3")
    }
```

**You may even combine multiple conditions in order to make the test enable**
```swift
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
```
#### Benefits:
- Ensures that tests only run in supported environments.
- Helps prevent test failures due to unsupported conditions.
- Can be used to test new features selectively.
---
## 🔥 **Known Issues**
### 🔹 Use `withKnownIssue()` to mark issues as known. 
The `withKnownIssue()` function marks a test as failing due to a **known issue**, preventing it from being considered a new failure. This helps maintain visibility on persistent issues without causing unnecessary test noise.

**The simplest way to expect a throw from the asyncRequest() call. Mark test as failed if don't receive any exception thrown.**
```swift
        let expectedError = TestError.dataStoreFetchFailure
        self.mockDataStore.error = expectedError
        await withKnownIssue("Expected a throw error happens during the asyncRequest() call") {
            let result = try await self.sut.asyncRequest()
            #expect(result == mockData)
        }
```

**A more specific way to check the throw exception is matching the expected one. Pass the test if matched, fail otherwise.**
```swift
        try await withKnownIssue("Expect a .dataStoreFetchFailure error only when dataStoreIsDown, fail this test if received other error.", {
            let result = try await self.sut.asyncRequest()
            #expect(result == mockData)
        }, when: {
            return dataStoreIsDown
        }, matching: { issue in
            return (issue.error as? TestError) == .dataStoreFetchFailure
        })
```
#### Benefits:
- Prevents false negatives: Marks failures as expected instead of actual test failures.
- Improves visibility: Clearly documents known issues directly within test cases.
- Facilitates debugging: Helps prioritize bug fixes without affecting overall test results.
- Encourages tracking: Known issues remain visible until they are resolved.
---
## 🔥 **Limiting the running time of tests**
### 🔹 Use `.timeLimit()` trait to maximum the time a test is allowed to run
The `.timeLimit()` trait specifies the maximum time a test is allowed to run before being marked as failed. This helps in identifying slow tests and maintaining efficient test execution.
This lets you specify how many minutes – yes, minutes – the test should be allowed to run for before it's considered a failure.
Currently Apple only allows to set the timeLimit in mintue unit.

```swift
    @Test("Expected Time Limit Error", .timeLimit(.minutes(1)))
    func exceededTimeLimit() async throws {
        try await Task.sleep(until: .now + .seconds(65))
    }
```

#### Benefits:
- Ensures performance consistency: Prevents unexpected slowdowns in critical code.
- Detects regressions: Identifies when a function or algorithm becomes slower over time.
- Encourages optimization: Enforces best practices for writing efficient tests.
---
## 🔥 **Running tests serially or in parallel**
### 🔹 Make the tests in suite to run in serial by using `.serialized` trait
By default, Swift Testing runs tests in parallel to improve efficiency and reduce total test execution time. This is useful for independent test cases that do not share mutable state.

**Make the tests run in a serial base.**
```swift
@Suite(.serialized) struct SerialTests {
    // This function will be invoked serially, once per input, because the
    // containing suite has the .serialized trait.
    @Test(arguments: 0...10)
    func addition(input: Int) {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, input)
        #expect(result == 1+input, "Expected 1 + \(input) to equal \(1+input)")
    }
    
    // This function will not run while addition(input:) is running. One test
    // must end before the other will start.
    @Test(.tags(Tag.subtraction))
    func subtraction() {
        let mathOperations = MathOperations()
        let result = mathOperations.subtract(10, 3)
        #expect(result == 7, "Expected 10 - 3 to equal 7")
    }
}
```

**Make the tests run in a parallel base.**
```swift
@Suite struct ParallelTests {
    // This function will be invoked parallely, all tests run in parallel.
    @Test(arguments: 0...10)
    func addition(input: Int) {
        let mathOperations = MathOperations()
        let result = mathOperations.add(1, input)
        #expect(result == 1+input, "Expected 1 + \(input) to equal \(1+input)")
    }
    
    // This function will be invoked parallely with addition(input:).
    @Test(.tags(Tag.subtraction))
    func subtraction() {
        let mathOperations = MathOperations()
        let result = mathOperations.subtract(10, 3)
        #expect(result == 7, "Expected 10 - 3 to equal 7")
    }
}
```
#### Benefits:
- Faster test execution: Runs multiple tests concurrently, reducing total test time.
- Efficient resource usage: Utilizes available CPU cores more effectively.
- Great for independent tests: Works well when tests do not modify shared state.
---
## 🔥 **Adding tags to tests**
### 🔹 Use `.tags()` to group a list of tests
Test tags are custom labels assigned to tests using the `.tags()` trait. They allow tests to be grouped and selectively executed based on their assigned tags.

**Defining the tags**
```swift
extension Tag {
  @Tag static var subtraction: Self
}

extension Tag {
  enum com_chris_swiftTesting {}
}

extension Tag.com_chris_swiftTesting {
  @Tag static var extraSpecial: Tag
}
```

**Assigning tags to tests**
```swift
@Test(.tags(Tag.com_chris_swiftTesting.extraSpecial)) {}
@Test(.tags(Tag.subtraction)) {}
```
#### Benefits:
- Run targeted test groups: Execute only a subset of tests based on their tags.
- Improve test organization: Categorize tests by feature, priority, or functionality.
- Faster debugging: Focus on specific tests when investigating failures.
---
## 🔥 **Bugs Tracking**
### 🔹 Use `.bug()` trait to track a test
The `.bug()` trait is used to mark tests that fail due to a known bug. It helps in categorizing and filtering these tests during test execution.

```swift
    // Just set a bug URL
    @Test(
        "Test with bug URL",
        .bug("http://company.com/bugs/12345")
    )

    // Assigning both the bug URL and ID
    @Test(
        "Test with bug URL and ID",
        .bug("http://company.com/bugs/12345", id: "12345")
    )

    // Set all the bug URL, ID and title
    @Test(
        "Test with bug URL, ID and title",
        .bug("http://company.com/bugs/12345", id: 12345, "A bug leads to flaky tests")
    )

    // Relating to multiple bugs
    @Test(
        "Test with bug URL, ID and title",
        .bug("http://company.com/bugs/12345", id: 12345, "A bug leads to flaky tests"),
        .bug("http://company.com/bugs/67890", id: 67890, "Another bug leads to flaky tests")
    )
```
#### Benefits:
- Tracks known issues: Associates failing tests with specific bug reports.
- Improves visibility: Developers can quickly identify which tests are failing due to known defects.
- Facilitates debugging: Helps prioritize bug fixes and track progress.
---

### **Conclusion**
Swift Testing is the next evolution in testing for Swift applications, making it easier and more efficient than XCTest or third-party frameworks like Quick/Nimble. By adopting Swift Testing, you can reduce boilerplate, improve test clarity, and integrate seamlessly with modern Swift features.

For more details, visit [Apple's Swift Testing Documentation](https://developer.apple.com/xcode/swift-testing/).