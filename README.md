# Rumour - A P2P Chat App with MultipeerConnectivity

Rumour is a simple peer-to-peer chat application built with SwiftUI and Apple's MultipeerConnectivity framework. It allows users to discover nearby devices, connect to them, and exchange messages without requiring an internet connection or a server.

## Features

- Discover nearby devices using Bluetooth and Wi-Fi
- Connect to other devices for direct messaging
- Real-time messaging with other connected peers
- Visual indicators showing connection status
- Simple and intuitive user interface

## Requirements

- iOS 15.0+ / macOS 12.0+
- Xcode 15.0+
- Swift 5.5+

## Setup

1. Clone the repository to your local machine
2. Open the Xcode project file
3. Ensure that Info.plist has the following permissions:
   - `NSLocalNetworkUsageDescription` - Rumour uses the local network to discover and connect to nearby devices for chatting.
   - `NSBonjourServices` - Array with `_rumour-chat._tcp` and `_rumour-chat._udp` entries
   - `NSBluetoothAlwaysUsageDescription` - Rumour uses Bluetooth to discover and connect to nearby devices for chatting.
4. Run the app on multiple devices to test the chat functionality

## Project Structure

The app is organized into the following directories:

- **Models**: Contains the data models for the app
  - `ChatMessage.swift`: Defines the structure of chat messages
  
- **Views**: Contains the SwiftUI views for the user interface
  - `ContentView.swift`: The main view of the app
  - `MessageBubble.swift`: Custom view for chat message bubbles
  - `PeersView.swift`: View for discovering and connecting to peers
  
- **Services**: Contains service classes for app functionality
  - `MultipeerService.swift`: Handles the MultipeerConnectivity networking

## Testing

The app includes a comprehensive test suite to verify functionality:

- **Model Tests**: Verify the data structures work correctly
- **Service Tests**: Test the networking and message handling
- **View Tests**: Ensure UI components display and behave as expected
- **Mock Objects**: Support testing without requiring actual peer connections

To run tests:
1. Open the project in Xcode
2. Select Product > Test (or press Cmd+U)

See `RumourTests/README.md` for detailed information about the test suite.

## Usage

1. Launch the app on two or more devices that are in proximity
2. Tap the "person.2.fill" icon in the top-right to open the Peers view
3. Each device should see the other in the list of available peers
4. Tap on a discovered peer to send a connection invitation
5. Once connected, return to the main view and start sending messages

## Implementation Notes

The app utilizes Apple's MultipeerConnectivity framework, which provides peer-to-peer connectivity and the ability to discover services provided by nearby devices. The implementation includes:

- MCSession for managing connections to peers
- MCNearbyServiceAdvertiser for advertising the availability of the app to nearby peers
- MCNearbyServiceBrowser for discovering other instances of the app on nearby devices

The app requires Bluetooth and/or Wi-Fi to function properly.

## License

This project is released under the MIT License. 