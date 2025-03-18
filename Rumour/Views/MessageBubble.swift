//
//  MessageBubble.swift
//  Rumour
//
//  Created by Marko Mijatovic on 18.3.25..
//

import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromSelf {
                Spacer()
                messageContent
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                messageContent
                    .background(Color(.systemGray5))
                    .foregroundColor(.black)
                    .clipShape(.rect(cornerRadius: 12))
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    private var messageContent: some View {
        VStack(alignment: message.isFromSelf ? .trailing : .leading, spacing: 4) {
            if !message.isFromSelf {
                Text(message.sender)
                    .font(.caption)
                    .foregroundColor(message.isFromSelf ? .white.opacity(0.8) : .gray)
                    .padding(.horizontal, 10)
                    .padding(.top, 5)
            }
            
            Text(message.text)
                .padding(10)
            
            Text(timeFormatter.string(from: message.timestamp))
                .font(.caption2)
                .foregroundColor(message.isFromSelf ? .white.opacity(0.8) : .gray)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
        }
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageBubble(message: ChatMessage(
                text: "Hello there!",
                sender: "Me",
                isFromSelf: true
            ))
            
            MessageBubble(message: ChatMessage(
                text: "Hi! How are you?",
                sender: "Friend",
                isFromSelf: false
            ))
        }
    }
} 
