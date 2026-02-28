# ATV Remote (Android TV Remote App)

An open-source Android TV remote application built with Flutter, Riverpod, and a native Kotlin robust background system.

## How to run project

1. **Requirements:**
   - Flutter SDK (>=3.10.0 <4.0.0)
   - Android Studio (or command line tools) with an emulator or physical Android device.
   - An Android TV or Google TV on the same local network for pairing and testing.
2. **Setup:**
   - Run `flutter pub get` to fetch dependencies.
   - Run `dart run build_runner build -d` to generate Riverpod and Hive files if needed.
3. **Execution:**
   - Run `flutter run` on an Android device to build and launch the application.

## Architecture explanation

The application is built using a hybrid architecture, combining the rich UI capabilities of Flutter with the background system stability of native Android.

### Flutter (Frontend & State)
- **State Management:** Uses `Riverpod` for reactive, immutable state management, combined with `fpdart` for functional programming paradigms (handling eithers/options).
- **Local Storage:** `Hive` is used for fast local storage of paired devices and settings.
- **Routing:** `go_router` manages declarative UI navigation.

### Native Android (Background & Connectivity)
- **Persistent Connection:** `AtvMediaService` is a robust Foreground Service that maintains the socket connection to the TV even when the app is minimized.
- **Media Session Integration:** Connects to the Android `MediaSessionCompat` framework to intercept physical volume button presses and manage audio focus seamlessly.
- **State Machine:** Uses `ConnectionSupervisor` to rigorously manage the connection lifecycle (Connecting, Idle, Connected, AuthFailed) and handles exponential backoff for reconnections.
- **Quick Settings & Lock Screen:** Exposes `AtvTileService` to provide a Quick Settings Tile for immediate remote access without opening the app.

## TV Protocol explanation

The application communicates with Android TVs using a reverse-engineered Google TV pairing and remote protocol via Protocol Buffers (`protobuf`).

### Pairing Protocol (Port 6467)
1. **Discovery:** Discovers TVs via Network Service Discovery (mDNS).
2. **Initiation:** Client starts a `PairingRequest` identifying its service name and device name.
3. **Configuration:** Exchanges `PairingOption` and `PairingConfiguration` to agree on the input role and hexadecimal encoding for the PIN.
4. **Authentication:** The TV displays a 6-digit PIN. The client normalizes it and uses it to derive a `PairingSecret` using the client's and TV's certificates.
5. **Mutual TLS (mTLS):** On success, both the TV and Client certificates are saved to the `CertificateStore`.

### Remote Protocol (Port 6466)
1. **Secure Handshake:** Establishes an SSLSocket utilizing the certificates exchanged during pairing (mTLS). It configures TLSv1.2 (falling back to TLSv1.3 if needed) with Server Name Indication (SNI).
2. **Feature Negotiation:** Exchanges `RemoteConfigure` and `RemoteSetActive` to agree on supported remote features (e.g., volume control, D-pad).
3. **Keep-alive:** Periodic `RemotePingRequest` / `RemotePingResponse` are sent to prevent idle timeouts.
4. **Key Injection:** Commands are encapsulated in `RemoteKeyInject` protobuf messages specifying the key code (e.g., up, down, home, back) and direction (press/release).

## Known Limitations

- **Android Only Background Services:** Advanced features like the Quick Settings Tile, physical volume button interception, and persistent foreground service are implemented in Kotlin and currently only available on Android.
- **Battery Optimization:** Aggressive OEM battery optimizations (e.g., on Samsung, Xiaomi) might kill the background service. It is recommended to set the app's battery usage to "Unrestricted".
- **Audio Focus Conflicts:** If another media application aggressively requests audio focus, the remote's media session may be suspended, disabling physical volume button routing until the app is reopened or regains focus.
- **Protocol Variability:** Some older Android TVs or heavily modified OEM skins might implement the pairing protocol differently, leading to rejected configurations or handshake failures.
- **Same Network Requirement:** The phone and the TV must reside on the exact same local network subnet for mDNS discovery and local socket connections to work properly.
