//
//  ContentView.swift
//  Rumour
//
//  Created by Marko Mijatovic on 18.3.25..
//

import SwiftUI
import MultipeerConnectivity

struct ContentView: View {
    @EnvironmentObject var multipeerService: MultipeerService
    @State private var messageText = ""
    @State private var isShowingPeers = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Connected peers indicator
                connectionStatusBar
                
                // Message list
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(multipeerService.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.vertical)
                    }
                    .background(Color(.systemGroupedBackground))
                    .onChange(of: multipeerService.messages) { _ in
                        if let lastMessage = multipeerService.messages.last {
                            withAnimation {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Message input bar
                messageInputBar
            }
            .navigationTitle("Rumour")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingPeers = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2")
                            Text("\(multipeerService.connectedPeers.count)")
                                .font(.caption)
                                .padding(4)
                                .background(
                                    Circle()
                                        .fill(Color.blue.opacity(0.2))
                                )
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingPeers) {
                PeersView(multipeerService: multipeerService, isShowingPeers: $isShowingPeers)
            }
        }
    }
    
    private var connectionStatusBar: some View {
        HStack {
            if multipeerService.connectedPeers.isEmpty {
                Label("Not Connected", systemImage: "wifi.slash")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red.opacity(0.1))
                    )
            } else {
                Label("\(multipeerService.connectedPeers.count) Connected", systemImage: "wifi")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.green.opacity(0.1))
                    )
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
    
    private var messageInputBar: some View {
        HStack(spacing: 12) {
            TextField("Message", text: $messageText)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(.systemGray6))
                )
                .textFieldStyle(.plain)
            
            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(messageText.isEmpty ? .gray : .blue)
            }
            .disabled(messageText.isEmpty)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        multipeerService.send(message: messageText)
        messageText = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MultipeerService(peerId: MCPeerID(displayName: "Test")))
    }
}
