# 📺 ATV Remote — Android TV Remote Control

> A powerful, open-source Flutter application to control your Android TV over Wi-Fi using the official Android TV Remote Control Protocol v2.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat&logo=flutter)
![Kotlin](https://img.shields.io/badge/Kotlin-Native-7F52FF?style=flat&logo=kotlin)
![Android](https://img.shields.io/badge/Android-TV-3DDC84?style=flat&logo=android)
![License](https://img.shields.io/badge/License-Proprietary-red?style=flat)
![Platform](https://img.shields.io/badge/Platform-Android-green?style=flat)

---

## 📱 Overview

ATV Remote is a Flutter-based Android TV remote control app built with **clean architecture**, **Riverpod state management**, and a **Kotlin-native networking layer**. Unlike typical Flutter remotes that rely on pure Dart networking, this app uses native Android APIs for reliable device discovery and secure TLS-based pairing — the same way Google's own remote works.

---

## ✨ Features

- 🔍 **Automatic Device Discovery** — Finds Android TVs on your local network using mDNS/NSD (no manual IP entry needed)
- 🔐 **Secure TLS Pairing** — Full Android TV Remote Control Protocol v2 over encrypted TCP connection
- 🎮 **Full Remote Controls** — D-Pad, volume, media playback, navigation, home, back, and more
- ⌨️ **Keyboard Input** — Type directly into your TV from your phone keyboard
- 📡 **ADB over Network** — Optional ADB channel support for power users
- 💾 **Saved Devices** — Remembers your paired TVs for instant reconnection
- 🌙 **Clean UI** — Material Design 3 interface optimized for one-handed remote use

---

## 🏗️ Architecture

This app follows **Clean Architecture** with a strict separation of concerns across three layers:

```
lib/
├── data/
│   ├── datasources/
│   │   └── native/          # Flutter ↔ Kotlin bridge via MethodChannel
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/            # TvDevice, RemoteCommand, PairingStatus, etc.
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/           # Riverpod providers (state management)
    └── screens/
        ├── discovery/       # TV scanning UI
        ├── pairing/         # PIN entry flow
        ├── remote/          # Main remote control screen
        ├── settings/
        └── splash/
```

### Kotlin Native Layer (Android)

```
android/.../atv_remote/
├── adb/                     # ADB session management
├── channels/                # MethodChannel + EventChannel bridges
│   ├── ChannelManager
│   ├── DiscoveryChannel
│   ├── PairingChannel
│   ├── RemoteChannel
│   └── NetworkChannel
├── discovery/
│   ├── NsdDiscoveryEngine    # Android NsdManager for mDNS
│   └── DiscoveredDevice
├── pairing/                 # 🔒 Proprietary — not included in public repo
│   ├── PairingManager
│   ├── MessageFramer
│   └── [TLS implementation files — private]
└── remote/
    ├── RemoteSession
    ├── ConnectionSupervisor
    └── AtvMediaService
```

---

## 🔧 Technical Deep Dive

### Why Kotlin-Native Networking?

Pure Flutter/Dart networking proved unreliable for Android TV pairing due to:

- **mDNS multicast restrictions** on Android — `NsdManager` is the only reliable API
- **TLS complexity** — custom `TrustManager` needed to accept the TV's self-signed certificate
- **Protocol timing** — `PairingRequest` must be sent *immediately* after TLS handshake, before PIN display

The solution: a full Kotlin-native networking stack exposed to Flutter via `MethodChannel` and `EventChannel`.

### Protocol: Android TV Remote Control Protocol v2

| Detail | Value |
|--------|-------|
| Transport | TCP over TLS |
| Port | `6466` |
| Discovery | mDNS (`_androidtvremote2._tcp`) |
| Encoding | Manual Protobuf (proto2) |
| Pairing | PIN-based certificate exchange |
| Certificate | Self-signed, stored per device |

### Key Protocol Insight

> ⚠️ **Critical:** `PairingRequest` must be sent **immediately after the TLS handshake** — before waiting for PIN input from the user. Most open-source implementations fail here.

### Flutter ↔ Kotlin Bridge

```
Flutter (Dart)          MethodChannel           Kotlin
──────────────────────────────────────────────────────
discovery_provider  ──→  DiscoveryChannel  ──→  NsdDiscoveryEngine
pairing_provider    ──→  PairingChannel    ──→  PairingManager
remote_provider     ──→  RemoteChannel     ──→  RemoteSession
                   ←──  EventChannel       ←──  ConnectionSupervisor
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter `3.x` or later
- Android Studio / VS Code
- Android device running **Android 5.0+**
- Android TV on the **same Wi-Fi network**

### Installation

```bash
# Clone the repository
git clone https://github.com/Junaid546/Android-TV-Remote-.git

# Navigate to project
cd Android-TV-Remote-

# Install Flutter dependencies
flutter pub get

# Run on connected device
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

> **Note:** The release build uses R8 full-mode obfuscation. Ensure your `key.properties` signing config is set up before building for release.

---

## 📦 Dependencies

### Flutter / Dart

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `freezed` | Immutable data models |
| `go_router` | Navigation |
| `shared_preferences` | Persisting saved devices |
| `flutter_animate` | UI animations |

### Android / Kotlin

| API / Library | Purpose |
|--------------|---------|
| `NsdManager` | mDNS device discovery |
| `SSLSocket` | TLS-encrypted TCP connection |
| Custom `TrustManager` | Accept TV's self-signed cert |
| `MethodChannel` | Flutter ↔ Kotlin communication |
| `EventChannel` | Kotlin → Flutter event streaming |

---

## 🔐 Security

This app implements several layers of protection:

- **TLS encryption** on all TV communication (no plaintext traffic)
- **Certificate pinning** per paired device — certificates stored locally
- **R8 obfuscation** on release builds — class names and logic are scrambled
- **Anti-tamper checks** — app verifies its own APK signature at runtime
- **Sensitive pairing implementation** excluded from public repository

> ⚠️ The files `TlsSocketFactory.kt`, `CertificateStore.kt`, and `PairingSecretGenerator.kt` contain proprietary TLS pairing logic and are **not included** in this public repository.

---

## 📁 Project Structure

```
ATV_REMOTE/
├── android/                  # Kotlin native layer
├── lib/                      # Flutter/Dart source
├── proto/
│   ├── pairing.proto         # Pairing protocol definitions
│   └── remote.proto          # Remote control protocol definitions
├── pubspec.yaml
└── README.md
```

---

## 🗺️ Roadmap

- [ ] iOS support (using Network framework for mDNS)
- [ ] Touchpad / swipe gesture control
- [ ] App launcher shortcut grid
- [ ] Wake-on-LAN support
- [ ] Multi-TV switching
- [ ] Widget / home screen quick controls

---

## 🤝 Contributing

Contributions are welcome for the public portions of the codebase. Please open an issue before submitting a PR for significant changes.

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'feat: add your feature'`
4. Push: `git push origin feature/your-feature`
5. Open a Pull Request

---

## ⚠️ Disclaimer

This app is an independent project and is **not affiliated with Google or Android**. The Android TV Remote Control Protocol is used in accordance with its publicly documented specification. Use on networks and devices you own or have permission to access.

---

## 👤 Author

**Junaid**
- Flutter Developer & Mobile Architect
- LinkedIn: [linkedin.com/in/junaid](www.linkedin.com/in/junaid-tahir-2905a035a)
- GitHub: [@Junaid546](https://github.com/Junaid546)

---

## 📄 License

Copyright © 2025 Junaid. All Rights Reserved.

The public portions of this project are available for reference and learning. The proprietary pairing implementation files are excluded and remain the intellectual property of the author.

---

<p align="center">Built with ❤️ using Flutter + Kotlin</p>
