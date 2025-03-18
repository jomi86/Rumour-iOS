# Setup Instructions for Rumour App

## Setting up the project in Xcode

To properly set up this project with all the necessary files and import statements, follow these steps:

1. **Check Info.plist**: Make sure your Info.plist contains the following entries:
   - `NSLocalNetworkUsageDescription`: Rumour uses the local network to discover and connect to nearby devices for chatting.
   - `NSBonjourServices`: Array with items `_rumour-chat._tcp` and `_rumour-chat._udp`
   - `NSBluetoothAlwaysUsageDescription`: Rumour uses Bluetooth to discover and connect to nearby devices for chatting.

2. **File Structure**: In Xcode, create the following group structure:
   - **Models**
     - ChatMessage.swift
   - **Views**
     - ContentView.swift
     - MessageBubble.swift
     - PeersView.swift
   - **Services**
     - MultipeerService.swift

3. **Import Fixes**: Ensure each file has the correct imports:
   
   **ChatMessage.swift**:
   ```swift
   import Foundation
   import MultipeerConnectivity
   ```

   **MultipeerService.swift**:
   ```swift
   import Foundation
   import MultipeerConnectivity
   import Combine
   import SwiftUI
   ```

   **MessageBubble.swift**:
   ```swift
   import SwiftUI
   ```

   **PeersView.swift**:
   ```swift
   import SwiftUI
   import MultipeerConnectivity
   ```

   **ContentView.swift**:
   ```swift
   import SwiftUI
   import MultipeerConnectivity
   ```

   **RumourApp.swift**:
   ```swift
   import SwiftUI
   ```

4. **Add Swift imports**: Make sure each file with type references includes the necessary imports:
   - Files that use `ChatMessage` should import the model directly using relative imports within the module, not using @_exported.
   - Files that use `MultipeerService` should reference it directly.
   - All UI views should be properly connected via the main app's environmentObject.

5. **Build and Run**: After organizing the files and fixing the imports, build and run the app to test connectivity.

## Troubleshooting Common Issues

- **Module Import Errors**: If you see "No such module" errors, make sure the files are included in the same target in your Xcode project.
- **Type Not Found Errors**: For "Cannot find type" errors, ensure you've added the correct import statements at the top of each file.
- **Main Attribute Errors**: If you see errors about the @main attribute, ensure there's only one @main entry point in your app.

## Testing the App

To test the peer-to-peer functionality:
1. Run the app on two or more devices
2. Ensure Bluetooth is enabled on all devices
3. Use the "person.2.fill" button to discover nearby peers
4. Connect to a peer by tapping their name
5. Exchange messages in the main chat view 