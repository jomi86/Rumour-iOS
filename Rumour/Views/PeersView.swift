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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if multipeerService.availablePeers.isEmpty {
                        HStack {
                            Image(systemName: "person.fill.questionmark")
                                .foregroundStyle(.secondary)
                            Text("No peers found nearby")
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    } else {
                        ForEach(multipeerService.availablePeers, id: \.self) { peer in
                            Button(action: {
                                multipeerService.invitePeer(peer)
                                dismiss()
                            }) {
                                HStack {
                                    Label(peer.displayName, systemImage: "person")
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.blue)
                                        .imageScale(.large)
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                } header: {
                    Label("Available Peers", systemImage: "person.2")
                }
                
                Section {
                    if multipeerService.connectedPeers.isEmpty {
                        HStack {
                            Image(systemName: "person.fill.xmark")
                                .foregroundStyle(.secondary)
                            Text("Not connected to any peers")
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    } else {
                        ForEach(multipeerService.connectedPeers, id: \.self) { peer in
                            HStack {
                                Label(peer.displayName, systemImage: "person.fill")
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .imageScale(.large)
                            }
                        }
                    }
                } header: {
                    Label("Connected Peers", systemImage: "person.2.fill")
                }
            }
            .navigationTitle("Nearby Devices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 
