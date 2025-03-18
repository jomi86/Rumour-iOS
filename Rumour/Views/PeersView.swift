//
//  PeersView.swift
//  Rumour
//
//  Created by Marko Mijatovic on 18.3.25..
//

import SwiftUI
import MultipeerConnectivity

struct PeersView: View {
    @ObservedObject var multipeerService: MultipeerService
    @Binding var isShowingPeers: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Available Peers")) {
                    if multipeerService.availablePeers.isEmpty {
                        Text("No peers found nearby")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(multipeerService.availablePeers, id: \.self) { peer in
                            Button(action: {
                                multipeerService.invitePeer(peer)
                                isShowingPeers = false
                            }) {
                                HStack {
                                    Text(peer.displayName)
                                    Spacer()
                                    Image(systemName: "person.fill.badge.plus")
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }
                
                Section(header: Text("Connected Peers")) {
                    if multipeerService.connectedPeers.isEmpty {
                        Text("Not connected to any peers")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        ForEach(multipeerService.connectedPeers, id: \.self) { peer in
                            HStack {
                                Text(peer.displayName)
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Nearby Devices")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        isShowingPeers = false
                    }
                }
            }
        }
    }
} 
