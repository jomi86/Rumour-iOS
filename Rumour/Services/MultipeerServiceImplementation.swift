//
//  MultipeerService.swift
//  Rumour
//
//  Created by Marko Mijatovic on 18.3.25..
//

import Foundation
import MultipeerConnectivity
import Combine
import SwiftUI

class MultipeerService: NSObject, ObservableObject {
    // Service type must be a unique string, up to 15 characters long
    // and can contain only ASCII lowercase letters, numbers, and hyphens
    private let serviceType = "rumour-chat"
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    private let session: MCSession
    
    private var myPeerId: MCPeerID
    
    @Published var availablePeers: [MCPeerID] = []
    @Published var connectedPeers: [MCPeerID] = []
    @Published var messages: [ChatMessage] = []
    
    init(peerId: MCPeerID, session: MCSession? = nil, advertiser: MCNearbyServiceAdvertiser? = nil, browser: MCNearbyServiceBrowser? = nil) {
        self.myPeerId = peerId
        
        // Use provided session or create new one
        self.session = session ?? MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        
        // Use provided advertiser or create new one
        self.serviceAdvertiser = advertiser ?? MCNearbyServiceAdvertiser(
            peer: peerId,
            discoveryInfo: nil,
            serviceType: serviceType
        )
        
        // Use provided browser or create new one
        self.serviceBrowser = browser ?? MCNearbyServiceBrowser(
            peer: peerId,
            serviceType: serviceType
        )
        
        super.init()
        
        self.session.delegate = self
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
        
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func send(message: String) {
        if !connectedPeers.isEmpty, !message.isEmpty {
            do {
                let chatMessage = ChatMessage(id: UUID(), text: message, sender: myPeerId.displayName, isFromSelf: true)
                
                // Add the message to our local messages array
                DispatchQueue.main.async {
                    self.messages.append(chatMessage)
                }
                
                // Create a dictionary representation of the message for sending
                let messageDict: [String: String] = [
                    "text": message,
                    "sender": myPeerId.displayName,
                    "id": chatMessage.id.uuidString
                ]
                
                // Convert dictionary to Data
                let messageData = try JSONEncoder().encode(messageDict)
                
                // Send the data to all connected peers
                try session.send(messageData, toPeers: connectedPeers, with: .reliable)
            } catch {
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }
    
    func invitePeer(_ peerID: MCPeerID) {
        serviceBrowser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
}

// MARK: - MCSessionDelegate
extension MultipeerService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            // Update connectedPeers based on current session.connectedPeers
            self.connectedPeers = session.connectedPeers
            
            // Print connection status for debugging
            switch state {
            case .connected:
                print("Connected to: \(peerID.displayName)")
            case .connecting:
                print("Connecting to: \(peerID.displayName)")
            case .notConnected:
                print("Disconnected from: \(peerID.displayName)")
            @unknown default:
                print("Unknown state for peer: \(peerID.displayName)")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            do {
                // Try to decode the message data
                if let messageDict = try JSONSerialization.jsonObject(with: data) as? [String: String],
                   let text = messageDict["text"],
                   let sender = messageDict["sender"],
                   let idString = messageDict["id"],
                   let id = UUID(uuidString: idString) {
                    
                    // Create a ChatMessage from the decoded data
                    let message = ChatMessage(id: id, text: text, sender: sender, isFromSelf: false)
                    
                    // Add the message to our messages array
                    self.messages.append(message)
                }
            } catch {
                print("Error decoding received message: \(error.localizedDescription)")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // Not used in this implementation
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // Not used in this implementation
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // Not used in this implementation
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Auto-accept connections
        invitationHandler(true, session)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("Failed to start advertising: \(error.localizedDescription)")
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension MultipeerService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        DispatchQueue.main.async {
            if !self.availablePeers.contains(peerID) {
                self.availablePeers.append(peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.availablePeers.removeAll { $0 == peerID }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print("Failed to start browsing: \(error.localizedDescription)")
    }
} 
