# Rumour App Testing Guide

This folder contains unit tests for the Rumour chat application built with SwiftUI and Apple's MultipeerConnectivity framework.

## Test Structure

The tests are organized into several categories:

1. **Model Tests**: Tests for the data model classes
   - `ChatMessageTests.swift` - Tests the ChatMessage model

2. **Service Tests**: Tests for the service layer
   - `MultipeerServiceTests.swift` - Tests the MultipeerService class
   - `MockServiceTests.swift` - Shows how to use the mock service for testing

3. **View Tests**: Tests for the SwiftUI views
   - `MessageBubbleTests.swift` - Tests the message bubble view
   - `ContentViewTests.swift` - Tests the main view
   - `PeersViewTests.swift` - Tests the peer discovery view

4. **Mocks**: Mock implementations for testing
   - `MockMultipeerService.swift` - A mock of the MultipeerService for testing views

## Running the Tests

To run the tests in Xcode:

1. Open the Rumour project in Xcode
2. Select the "Product" menu
3. Choose "Test" (Cmd+U)

To run specific test classes or methods:
1. Open the Test Navigator (Cmd+6)
2. Right-click on a test class or method
3. Select "Run"

## Note on XCTest Linter Errors

When working with the tests, you might see linter errors such as "No such module 'XCTest'" or "No such module 'Rumour'". These are usually related to the way the test target is set up in Xcode.

To fix these issues:

1. Make sure the test target's "Target Dependencies" includes the main app target
2. Ensure all test files are included in the test target
3. In Xcode, try cleaning the build folder (Shift+Cmd+K) and rebuilding the project

## Writing New Tests

When adding new tests:

1. Follow the naming convention: `[ClassName]Tests.swift`
2. Always import both XCTest and the module being tested:
   ```swift
   import XCTest
   @testable import Rumour
   ```
3. Each test class should inherit from `XCTestCase`
4. Use setUp() and tearDown() methods for test initialization and cleanup
5. Name test methods starting with "test" followed by what is being tested
6. Use XCTAssert methods to verify expected behaviors

## Using the Mock Service

The `MockMultipeerService` is designed to make testing views easier:

```swift
// Example of testing with the mock service
func testSomeView() {
    // Create the mock with initial data if needed
    let mockService = MockMultipeerService(
        availablePeers: MockMultipeerService.createMockPeers(count: 3),
        connectedPeers: MockMultipeerService.createMockPeers(count: 1),
        messages: MockMultipeerService.createMockMessages(count: 5)
    )
    
    // Create the view with the mock service
    let view = SomeView().environmentObject(mockService)
    
    // Perform view actions
    // ...
    
    // Verify the service was called correctly
    XCTAssertTrue(mockService.sendMessageCalled)
    XCTAssertEqual(mockService.sendMessageParam, "Expected message")
}
```

## Testing MultipeerConnectivity

Testing the MultipeerConnectivity framework directly can be challenging because it requires real devices to create actual connections. The tests in this project demonstrate how to:

1. Test the initialization of the service
2. Test behavior when no peers are connected
3. Test message handling logic
4. Mock peer discovery and connection

For full integration testing, you'll need to run the app on physical devices.

## ViewInspector Integration

These tests are set up to work with ViewInspector, a framework for testing SwiftUI views. To use it:

1. Add ViewInspector to your project dependencies
2. Make your views conform to Inspectable
3. Use the ViewInspector API to inspect and interact with views

Example (pseudo-code):
```swift
import ViewInspector

extension ContentView: Inspectable { }

func testContentView() throws {
    let view = ContentView().environmentObject(mockService)
    let textField = try view.inspect().find(ViewType.TextField.self)
    try textField.setInput("New message")
    // ...
}
``` 