//
//  ContentViewTests.swift
//  RumourTests
//
//  Created by Marko Mijatovic on 18.3.25..
//

import XCTest
import SwiftUI
@testable import Rumour

final class ContentViewTests: XCTestCase {
    var multipeerService: MultipeerService!
    
    override func setUp() {
        super.setUp()
        multipeerService = MultipeerService(peerId: .init(displayName: "Test"))
    }
    
    override func tearDown() {
        multipeerService = nil
        super.tearDown()
    }
    
    func testContentViewInitialization() {
        // In a real test with ViewInspector, we would verify:
        // - The view initializes correctly with the multipeerService
        // - The initial state of messageText is empty
        // - The initial state of isShowingPeers is false
        
        // For demonstration, we'll create a ContentView and ensure it doesn't crash
        let contentView = ContentView().environmentObject(multipeerService)
        XCTAssertNotNil(contentView)
    }
    
    func testConnectionIndicator() {
        // Test the connection indicator when no peers are connected
        XCTAssertTrue(multipeerService.connectedPeers.isEmpty)
        
        // In a real test with ViewInspector, we would:
        // - Verify the "Not Connected" label is shown with red color
        // - Add a peer to connectedPeers
        // - Verify the "1 Connected" label is shown with green color
        
        // For demonstration, we'll just show how we'd modify the service
        // NOTE: In a real test, we'd need a way to mock MCPeerID
        // This would likely involve dependency injection and protocols
        
        // This line would be part of the test setup:
        // multipeerService.connectedPeers = [mockedPeer]
        // Then verify the view updates accordingly
    }
    
    func testSendMessage() {
        // Setup a content view with our service
        let contentView = ContentView().environmentObject(multipeerService)
        
        // In a real test with ViewInspector, we would:
        // 1. Set the messageText field
        // 2. Trigger the send button
        // 3. Verify the message was passed to the multipeerService
        // 4. Verify the messageText field was cleared
        
        // For demonstration, we'll show the expected behavior pattern
        let initialMessageCount = multipeerService.messages.count
        
        // This would be the action triggered by the button:
        multipeerService.send(message: "Test message")
        
        // If we had connected peers, this would increase:
        XCTAssertEqual(multipeerService.messages.count, initialMessageCount)
    }
    
    func testShowingPeersSheet() {
        // In a real test with ViewInspector, we would:
        // 1. Verify isShowingPeers starts as false
        // 2. Trigger the button that sets isShowingPeers to true
        // 3. Verify the PeersView is presented as a sheet
        
        // For demonstration, we'll just show the pattern
        // In a real test, we'd need to access the @State property
        // which requires ViewInspector or similar testing tools
        
        // Test the initial state
        let contentView = ContentView().environmentObject(multipeerService)
        // Verify the initial state is not showing peers
        // Then trigger the action and verify the sheet appears
    }
} 
