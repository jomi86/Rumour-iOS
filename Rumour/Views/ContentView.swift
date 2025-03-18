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
        NavigationView {
            VStack {
                // Connected peers indicator
                HStack {
                    if multipeerService.connectedPeers.isEmpty {
                        Label("Not Connected", systemImage: "wifi.slash")
                            .foregroundColor(.red)
                    } else {
                        Label("\(multipeerService.connectedPeers.count) Connected", systemImage: "wifi")
                            .foregroundColor(.green)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // Message list
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack {
                            ForEach(multipeerService.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding(.top)
                    }
                    .onChange(of: multipeerService.messages) { _ in
                        if let lastMessage = multipeerService.messages.last {
                            withAnimation {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Message input bar
                HStack {
                    TextField("Message", text: $messageText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    
                    Button(action: {
                        sendMessage()
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(messageText.isEmpty ? .gray : .blue)
                    }
                    .disabled(messageText.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Rumour")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingPeers = true
                    }) {
                        Image(systemName: "person.2.fill")
                    }
                }
            }
            .sheet(isPresented: $isShowingPeers) {
                PeersView(multipeerService: multipeerService, isShowingPeers: $isShowingPeers)
            }
        }
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
