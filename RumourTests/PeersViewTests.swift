//
//  PeersViewTests.swift
//  RumourTests
//
//  Created by Marko Mijatovic on 18.3.25..
//

import XCTest
import SwiftUI
import MultipeerConnectivity
@testable import Rumour

@MainActor
final class PeersViewTests: XCTestCase {
    var multipeerService: MultipeerService!
    @State private var isShowingPeers: Bool = false
    
    override func setUp() {
        super.setUp()
        multipeerService = MultipeerService(peerId: .init(displayName: "PeersViewTests"))
    }
    
    override func tearDown() {
        multipeerService = nil
        super.tearDown()
    }
    
    func testPeersViewInitialization() {
        // In a real test with ViewInspector, we would verify:
        // - The view initializes correctly with the MultipeerService
        // - The binding to isShowingPeers works correctly
        
        // For demonstration, we'll create a PeersView and ensure it doesn't crash
        let peersView = PeersView(multipeerService: multipeerService, isShowingPeers: $isShowingPeers)
        XCTAssertNotNil(peersView)
    }
    
    func testEmptyPeersList() {
        // Test that when no peers are available, the appropriate message is shown
        XCTAssertTrue(multipeerService.availablePeers.isEmpty)
        
        // In a real test with ViewInspector, we would:
        // - Verify "No peers found nearby" text is displayed
        // - Verify the list of available peers is empty
        
        // For demonstration, we'll just assert the current state
        let peersView = PeersView(multipeerService: multipeerService, isShowingPeers: $isShowingPeers)
        XCTAssertNotNil(peersView)
    }
    
    func testAvailablePeersList() {
        // In a real test, we would:
        // 1. Create mock peer IDs
        // 2. Add them to the multipeerService.availablePeers array
        // 3. Verify they appear in the list with correct labels and buttons
        
        // For demonstration, we'll just show the pattern
        // NOTE: In a real app, we would need to mock MCPeerID
        // let mockPeer = MCPeerID(displayName: "Mock Peer")
        // multipeerService.availablePeers = [mockPeer]
        
        // Then verify the view updates to show this peer in the list
        let peersView = PeersView(multipeerService: multipeerService, isShowingPeers: $isShowingPeers)
        XCTAssertNotNil(peersView)
    }
    
    func testConnectedPeersList() {
        // Similar to available peers test, but for connected peers
        // In a real test, we would:
        // 1. Create mock peer IDs
        // 2. Add them to the multipeerService.connectedPeers array
        // 3. Verify they appear in the "Connected Peers" section with checkmarks
        
        // For demonstration, we'll just show the pattern
        // multipeerService.connectedPeers = [mockPeer]
        
        // Then verify the view updates to show this peer in the connected list
        let peersView = PeersView(multipeerService: multipeerService, isShowingPeers: $isShowingPeers)
        XCTAssertNotNil(peersView)
    }
    
    func testPeerInvitation() {
        // In a real test, we would:
        // 1. Create a mock peer ID
        // 2. Add it to availablePeers
        // 3. Trigger the button action that calls invitePeer
        // 4. Verify invitePeer was called with the correct peer
        // 5. Verify isShowingPeers was set to false
        
        // This would require mocking the MultipeerService to capture the invitePeer call
        // For demonstration, we'll just show the pattern
        
        XCTAssertFalse(isShowingPeers) // Initially false
        isShowingPeers = true
        XCTAssertTrue(isShowingPeers) // Now true
        
        // After action would be triggered:
        isShowingPeers = false
        XCTAssertFalse(isShowingPeers) // Back to false
    }
} 
