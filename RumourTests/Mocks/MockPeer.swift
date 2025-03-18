//
//  MockPeer.swift
//  RumourTests
//
//  Created by Marko Mijatovic on 18.3.25..
//

import Foundation
import MultipeerConnectivity

/// A helper class for creating and manipulating MCPeerID objects in tests
class MockPeer {
    /// Create a single MCPeerID with a given name
    static func create(name: String) -> MCPeerID {
        return MCPeerID(displayName: name)
    }
    
    /// Create an array of MCPeerID objects with sequential names
    static func createMany(count: Int, prefix: String = "Mock Peer") -> [MCPeerID] {
        var peers = [MCPeerID]()
        for i in 1...count {
            peers.append(MCPeerID(displayName: "\(prefix) \(i)"))
        }
        return peers
    }
    
    /// Compare two MCPeerID objects by their display names
    static func areEqual(_ peer1: MCPeerID, _ peer2: MCPeerID) -> Bool {
        return peer1.displayName == peer2.displayName
    }
    
    /// Find a peer in an array by display name
    static func findPeerWithName(_ name: String, in peers: [MCPeerID]) -> MCPeerID? {
        return peers.first { $0.displayName == name }
    }
} 