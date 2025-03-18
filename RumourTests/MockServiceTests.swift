//
//  MockServiceTests.swift
//  RumourTests
//
//  Created by Marko Mijatovic on 18.3.25..
//

import XCTest
import MultipeerConnectivity
@testable import Rumour

final class MockServiceTests: XCTestCase {
    var mockService: MockMultipeerService!
    
    override func setUp() {
        super.setUp()
        mockService = MockMultipeerService()
    }
    
    override func tearDown() {
        mockService = nil
        super.tearDown()
    }
    
    func testMockServiceInitialization() {
        // Test that the service initializes with empty arrays
        XCTAssertTrue(mockService.availablePeers.isEmpty)
        XCTAssertTrue(mockService.connectedPeers.isEmpty)
        XCTAssertTrue(mockService.messages.isEmpty)
        
        // Test initialization with pre-populated arrays
        let mockPeers = MockMultipeerService.createMockPeers(count: 2)
        let mockMessages = MockMultipeerService.createMockMessages(count: 3)
        
        mockService = MockMultipeerService(
            availablePeers: mockPeers,
            messages: mockMessages
        )
        
        XCTAssertEqual(mockService.availablePeers.count, 2)
        XCTAssertTrue(mockService.connectedPeers.isEmpty)
        XCTAssertEqual(mockService.messages.count, 3)
    }
    
    func testSendMessageTracking() {
        // Test that sending a message updates the tracking variables
        XCTAssertFalse(mockService.sendMessageCalled)
        XCTAssertNil(mockService.sendMessageParam)
        
        mockService.send(message: "Hello world")
        
        XCTAssertTrue(mockService.sendMessageCalled)
        XCTAssertEqual(mockService.sendMessageParam, "Hello world")
        
        // Since there are no connected peers, no message should be added
        XCTAssertTrue(mockService.messages.isEmpty)
    }
    
    func testSendMessageWithConnectedPeers() {
        // Add a connected peer
        let peer = MCPeerID(displayName: "Test Peer")
        mockService.connectedPeers = [peer]
        
        // Send a message
        mockService.send(message: "Hello peer")
        
        // Now a message should be added to the messages array
        XCTAssertEqual(mockService.messages.count, 1)
        XCTAssertEqual(mockService.messages.first?.text, "Hello peer")
        XCTAssertEqual(mockService.messages.first?.sender, "Mock User")
        XCTAssertTrue(mockService.messages.first?.isFromSelf ?? false)
    }
    
    func testInvitePeer() {
        // Create a peer and add it to available peers
        let peer = MCPeerID(displayName: "Available Peer")
        mockService.availablePeers = [peer]
        
        // Verify initial state
        XCTAssertEqual(mockService.availablePeers.count, 1)
        XCTAssertTrue(mockService.connectedPeers.isEmpty)
        XCTAssertFalse(mockService.invitePeerCalled)
        XCTAssertNil(mockService.invitePeerParam)
        
        // Invite the peer
        mockService.invitePeer(peer)
        
        // Verify tracking variables
        XCTAssertTrue(mockService.invitePeerCalled)
        XCTAssertEqual(mockService.invitePeerParam?.displayName, "Available Peer")
        
        // Verify the peer was moved from available to connected
        XCTAssertTrue(mockService.availablePeers.isEmpty)
        XCTAssertEqual(mockService.connectedPeers.count, 1)
        XCTAssertEqual(mockService.connectedPeers.first?.displayName, "Available Peer")
    }
    
    func testHelperFunctions() {
        // Test createMockPeers
        let peers = MockMultipeerService.createMockPeers(count: 5)
        XCTAssertEqual(peers.count, 5)
        XCTAssertEqual(peers[0].displayName, "Mock Peer 1")
        XCTAssertEqual(peers[4].displayName, "Mock Peer 5")
        
        // Test createMockMessages with default isFromSelf
        let messages = MockMultipeerService.createMockMessages(count: 3)
        XCTAssertEqual(messages.count, 3)
        XCTAssertEqual(messages[0].text, "Mock message 1")
        XCTAssertEqual(messages[0].sender, "Other User")
        XCTAssertFalse(messages[0].isFromSelf)
        
        // Test createMockMessages with isFromSelf = true
        let selfMessages = MockMultipeerService.createMockMessages(count: 2, isFromSelf: true)
        XCTAssertEqual(selfMessages.count, 2)
        XCTAssertEqual(selfMessages[0].sender, "Me")
        XCTAssertTrue(selfMessages[0].isFromSelf)
    }
} 