class KeyCodes {
  const KeyCodes._();

  static const Map<String, int> codes = {
    'KEYCODE_DPAD_UP': 19,
    'KEYCODE_DPAD_DOWN': 20,
    'KEYCODE_DPAD_LEFT': 21,
    'KEYCODE_DPAD_RIGHT': 22,
    'KEYCODE_DPAD_CENTER': 23,
    'KEYCODE_BACK': 4,
    'KEYCODE_HOME': 3,
    'KEYCODE_VOLUME_UP': 24,
    'KEYCODE_VOLUME_DOWN': 25,
    'KEYCODE_VOLUME_MUTE': 164,
    'KEYCODE_POWER': 26,
    'KEYCODE_CHANNEL_UP': 166,
    'KEYCODE_CHANNEL_DOWN': 167,
    'KEYCODE_MEDIA_PLAY_PAUSE': 85,
    'KEYCODE_MEDIA_REWIND': 89,
    'KEYCODE_MEDIA_FAST_FORWARD': 90,
    'KEYCODE_MEDIA_STOP': 86,
    'KEYCODE_SETTINGS': 176,
    'KEYCODE_CAPTIONS': 175,
    'KEYCODE_TV_INPUT': 178,
    'KEYCODE_ESCAPE': 111,
    'KEYCODE_ENTER': 66,
    'KEYCODE_DEL': 67,
  };

  static int? fromName(String name) {
    if (codes.containsKey(name)) return codes[name];
    return int.tryParse(name);
  }
}
