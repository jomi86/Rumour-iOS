//
//  ChatMessage.swift
//  Rumour
//
//  Created by Marko Mijatovic on 18.3.25..
//

import Foundation
import MultipeerConnectivity

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let text: String
    let sender: String
    let timestamp: Date
    let isFromSelf: Bool
    
    init(id: UUID = UUID(), text: String, sender: String, isFromSelf: Bool, timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.sender = sender
        self.isFromSelf = isFromSelf
        self.timestamp = timestamp
    }
} 