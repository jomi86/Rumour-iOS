//
//  RumourApp.swift
//  Rumour
//
//  Created by Marko Mijatovic on 18.3.25..
//

import SwiftUI
import MultipeerConnectivity

@main
struct RumourApp: App {
    @StateObject private var multipeerService = MultipeerService(peerId: MCPeerID(displayName: Utils.deviceName))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(multipeerService)
        }
    }
}
