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
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromSelf {
                Spacer()
                messageContent
                    .background(Color.blue.gradient)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            } else {
                messageContent
                    .background(Color(.systemGray6).gradient)
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    private var messageContent: some View {
        VStack(alignment: message.isFromSelf ? .trailing : .leading, spacing: 4) {
            if !message.isFromSelf {
                Text(message.sender)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(message.isFromSelf ? .white.opacity(0.8) : .gray)
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
            }
            
            Text(message.text)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .multilineTextAlignment(message.isFromSelf ? .trailing : .leading)
            
            Text(timeFormatter.string(from: message.timestamp))
                .font(.caption2)
                .foregroundColor(message.isFromSelf ? .white.opacity(0.8) : .gray)
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            MessageBubble(message: ChatMessage(
                text: "Hello there! This is a longer message to see how it wraps.",
                sender: "Me",
                isFromSelf: true
            ))
            
            MessageBubble(message: ChatMessage(
                text: "Hi! How are you? I'm doing great today!",
                sender: "Friend",
                isFromSelf: false
            ))
        }
        .padding()
    }
} 
