class AppConstants {
  const AppConstants._();

  static const kPairingPort = 6467;
  static const kRemotePort = 6466;
  static const kDiscoveryServiceType = '_androidtvremote2._tcp';
  static const kDiscoveryTimeout = Duration(seconds: 30);
  static const kConnectionTimeout = Duration(seconds: 10);
  static const kReconnectDelay = Duration(seconds: 3);
  static const kMaxReconnectAttempts = 5;
  static const kPinExpirySeconds = 60;
  static const kKeepAliveInterval = Duration(seconds: 5);
  static const kAppName = 'TV Remote';
  static const kServiceName = 'androidtvremote2';

  // Android TV Key Codes
  static const int kKeyPower = 26;
  static const int kKeyBack = 4;
  static const int kKeyHome = 3;
  static const int kKeyMenu = 82;
  static const int kKeyUp = 19;
  static const int kKeyDown = 20;
  static const int kKeyLeft = 21;
  static const int kKeyRight = 22;
  static const int kKeySelect = 23;
  static const int kKeyVolumeUp = 24;
  static const int kKeyVolumeDown = 25;
  static const int kKeyMute = 164;
}
