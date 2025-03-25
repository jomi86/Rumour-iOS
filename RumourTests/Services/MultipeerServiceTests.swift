import XCTest
import MultipeerConnectivity
@testable import Rumour

// MARK: - Mocks
class MockMCSession: MCSession {
    var mockConnectedPeers: [MCPeerID] = []
    var mockDelegate: MCSessionDelegate?
    var sentData: Data?
    var sentPeers: [MCPeerID]?
    
    override var connectedPeers: [MCPeerID] {
        return mockConnectedPeers
    }
    
    override var delegate: MCSessionDelegate? {
        get { return mockDelegate }
        set { mockDelegate = newValue }
    }
    
    override func send(_ data: Data, toPeers peerIDs: [MCPeerID], with mode: MCSessionSendDataMode) throws {
        sentData = data
        sentPeers = peerIDs
    }
}

class MockMCNearbyServiceAdvertiser: MCNearbyServiceAdvertiser {
    var mockDelegate: MCNearbyServiceAdvertiserDelegate?
    var didStartAdvertising = false
    var didStopAdvertising = false
    
    override var delegate: MCNearbyServiceAdvertiserDelegate? {
        get { return mockDelegate }
        set { mockDelegate = newValue }
    }
    
    override func startAdvertisingPeer() {
        didStartAdvertising = true
    }
    
    override func stopAdvertisingPeer() {
        didStopAdvertising = true
    }
}

class MockMCNearbyServiceBrowser: MCNearbyServiceBrowser {
    var mockDelegate: MCNearbyServiceBrowserDelegate?
    var didStartBrowsing = false
    var didStopBrowsing = false
    var invitedPeer: MCPeerID?
    
    override var delegate: MCNearbyServiceBrowserDelegate? {
        get { return mockDelegate }
        set { mockDelegate = newValue }
    }
    
    override func startBrowsingForPeers() {
        didStartBrowsing = true
    }
    
    override func stopBrowsingForPeers() {
        didStopBrowsing = true
    }
    
    override func invitePeer(_ peerID: MCPeerID, to session: MCSession, withContext context: Data?, timeout: TimeInterval) {
        invitedPeer = peerID
    }
}

// MARK: - Tests
class MultipeerServiceTests: XCTestCase {
    var sut: MultipeerService!
    var mockPeerID: MCPeerID!
    var mockSession: MockMCSession!
    var mockAdvertiser: MockMCNearbyServiceAdvertiser!
    var mockBrowser: MockMCNearbyServiceBrowser!
    
    override func setUp() {
        super.setUp()
        mockPeerID = MCPeerID(displayName: "TestPeer")
        mockSession = MockMCSession(peer: mockPeerID, securityIdentity: nil, encryptionPreference: .required)
        mockAdvertiser = MockMCNearbyServiceAdvertiser(peer: mockPeerID, discoveryInfo: nil, serviceType: "test-service")
        mockBrowser = MockMCNearbyServiceBrowser(peer: mockPeerID, serviceType: "test-service")
        
        sut = MultipeerService(
            peerId: mockPeerID,
            session: mockSession,
            advertiser: mockAdvertiser,
            browser: mockBrowser
        )
    }
    
    override func tearDown() {
        sut = nil
        mockPeerID = nil
        mockSession = nil
        mockAdvertiser = nil
        mockBrowser = nil
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertEqual(sut.availablePeers.count, 0)
        XCTAssertEqual(sut.connectedPeers.count, 0)
        XCTAssertEqual(sut.messages.count, 0)
        XCTAssertTrue(mockAdvertiser.didStartAdvertising)
        XCTAssertTrue(mockBrowser.didStartBrowsing)
    }
    
    func testSendMessage() {
        // Given
        let message = "Test message"
        mockSession.mockConnectedPeers = [MCPeerID(displayName: "OtherPeer")]
        
        // When
        sut.send(message: message)
        
        // Then
        XCTAssertEqual(sut.messages.count, 1)
        XCTAssertEqual(sut.messages.first?.text, message)
        XCTAssertEqual(sut.messages.first?.sender, mockPeerID.displayName)
        XCTAssertTrue(sut.messages.first?.isFromSelf ?? false)
        
        // Verify data was sent
        XCTAssertNotNil(mockSession.sentData)
        XCTAssertEqual(mockSession.sentPeers?.count, 1)
    }
    
    func testSendEmptyMessage() {
        // Given
        let message = ""
        mockSession.mockConnectedPeers = [MCPeerID(displayName: "OtherPeer")]
        
        // When
        sut.send(message: message)
        
        // Then
        XCTAssertEqual(sut.messages.count, 0)
        XCTAssertNil(mockSession.sentData)
    }
    
    func testSendMessageWithNoConnectedPeers() {
        // Given
        let message = "Test message"
        mockSession.mockConnectedPeers = []
        
        // When
        sut.send(message: message)
        
        // Then
        XCTAssertEqual(sut.messages.count, 0)
        XCTAssertNil(mockSession.sentData)
    }
    
    func testInvitePeer() {
        // Given
        let peerToInvite = MCPeerID(displayName: "PeerToInvite")
        
        // When
        sut.invitePeer(peerToInvite)
        
        // Then
        XCTAssertEqual(mockBrowser.invitedPeer, peerToInvite)
    }
    
    func testSessionStateChange() {
        // Given
        let peerID = MCPeerID(displayName: "TestPeer")
        
        // When
        mockSession.mockDelegate?.session(mockSession, peer: peerID, didChange: .connected)
        
        // Then
        XCTAssertEqual(sut.connectedPeers.count, 1)
        XCTAssertEqual(sut.connectedPeers.first, peerID)
    }
    
    func testReceiveMessage() {
        // Given
        let peerID = MCPeerID(displayName: "Sender")
        let messageText = "Hello, World!"
        let messageDict: [String: String] = [
            "text": messageText,
            "sender": peerID.displayName,
            "id": UUID().uuidString
        ]
        let messageData = try! JSONSerialization.data(withJSONObject: messageDict)
        
        // When
        mockSession.mockDelegate?.session(mockSession, didReceive: messageData, fromPeer: peerID)
        
        // Then
        XCTAssertEqual(sut.messages.count, 1)
        XCTAssertEqual(sut.messages.first?.text, messageText)
        XCTAssertEqual(sut.messages.first?.sender, peerID.displayName)
        XCTAssertFalse(sut.messages.first?.isFromSelf ?? true)
    }
} 