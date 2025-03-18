//
//  ChatMessageTests.swift
//  RumourTests
//
//  Created by Marko Mijatovic on 18.3.25..
//

import XCTest
@testable import Rumour

final class ChatMessageTests: XCTestCase {
    func testChatMessageInitialization() {
        // Test with all parameters specified
        let id = UUID()
        let timestamp = Date()
        let message = ChatMessage(
            id: id,
            text: "Hello world",
            sender: "User1",
            isFromSelf: true,
            timestamp: timestamp
        )
        
        XCTAssertEqual(message.id, id)
        XCTAssertEqual(message.text, "Hello world")
        XCTAssertEqual(message.sender, "User1")
        XCTAssertEqual(message.isFromSelf, true)
        XCTAssertEqual(message.timestamp, timestamp)
        
        // Test with default parameters (id and timestamp)
        let defaultMessage = ChatMessage(
            text: "Hello again",
            sender: "User2",
            isFromSelf: false
        )
        
        XCTAssertNotNil(defaultMessage.id)
        XCTAssertEqual(defaultMessage.text, "Hello again")
        XCTAssertEqual(defaultMessage.sender, "User2")
        XCTAssertEqual(defaultMessage.isFromSelf, false)
        XCTAssertNotNil(defaultMessage.timestamp)
    }
    
    func testChatMessageEquality() {
        let id = UUID()
        let timestamp = Date()
        
        let message1 = ChatMessage(
            id: id,
            text: "Hello world",
            sender: "User1",
            isFromSelf: true,
            timestamp: timestamp
        )
        
        let message2 = ChatMessage(
            id: id,
            text: "Hello world",
            sender: "User1",
            isFromSelf: true,
            timestamp: timestamp
        )
        
        let message3 = ChatMessage(
            id: UUID(),  // Different ID
            text: "Hello world",
            sender: "User1",
            isFromSelf: true,
            timestamp: timestamp
        )
        
        XCTAssertEqual(message1, message2)
        XCTAssertNotEqual(message1, message3)
    }
} 