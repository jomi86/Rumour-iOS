//
//  MockMultipeerService.swift
//  RumourTests
//
//  Created by Marko Mijatovic on 18.3.25..
//

import Foundation
import MultipeerConnectivity
import Combine
@testable import Rumour

class MockMultipeerService: ObservableObject {
    @Published var availablePeers: [MCPeerID] = []
    @Published var connectedPeers: [MCPeerID] = []
    @Published var messages: [ChatMessage] = []
    
    // Track function calls for verification
    var sendMessageCalled = false
    var sendMessageParam: String?
    var invitePeerCalled = false
    var invitePeerParam: MCPeerID?
    
    // Initialize with optional peer arrays for testing
    init(availablePeers: [MCPeerID] = [], connectedPeers: [MCPeerID] = [], messages: [ChatMessage] = []) {
        self.availablePeers = availablePeers
        self.connectedPeers = connectedPeers
        self.messages = messages
    }
    
    // Mock implementation of send(message:)
    func send(message: String) {
        sendMessageCalled = true
        sendMessageParam = message
        
        // If we have connected peers, add the message to our local collection
        if !connectedPeers.isEmpty && !message.isEmpty {
            let chatMessage = ChatMessage(
                text: message,
                sender: "Mock User",
                isFromSelf: true
            )
            messages.append(chatMessage)
        }
    }
    
    // Mock implementation of invitePeer(_:)
    func invitePeer(_ peerID: MCPeerID) {
        invitePeerCalled = true
        invitePeerParam = peerID
        
        // Mock successful connection
        if !connectedPeers.contains(peerID) {
            connectedPeers.append(peerID)
        }
        
        // Remove from available peers
        availablePeers.removeAll { $0 == peerID }
    }
    
    // Helper to create mock peers
    static func createMockPeers(count: Int) -> [MCPeerID] {
        var peers: [MCPeerID] = []
        for i in 1...count {
            peers.append(MCPeerID(displayName: "Mock Peer \(i)"))
        }
        return peers
    }
    
    // Helper to create mock messages
    static func createMockMessages(count: Int, isFromSelf: Bool = false) -> [ChatMessage] {
        var messages: [ChatMessage] = []
        for i in 1...count {
            messages.append(ChatMessage(
                text: "Mock message \(i)",
                sender: isFromSelf ? "Me" : "Other User",
                isFromSelf: isFromSelf
            ))
        }
        return messages
    }
} 