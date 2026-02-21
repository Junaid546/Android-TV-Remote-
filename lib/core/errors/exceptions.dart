class NativeChannelException implements Exception {
  final String code;
  final String message;
  const NativeChannelException(this.code, this.message);

  @override
  String toString() => 'NativeChannelException(code: $code, message: $message)';
}

class DeviceNotFoundException implements Exception {
  final String ip;
  const DeviceNotFoundException(this.ip);

  @override
  String toString() => 'DeviceNotFoundException(ip: $ip)';
}

class TlsHandshakeException implements Exception {
  final String reason;
  const TlsHandshakeException(this.reason);

  @override
  String toString() => 'TlsHandshakeException(reason: $reason)';
}

class ProtocolException implements Exception {
  final String reason;
  const ProtocolException(this.reason);

  @override
  String toString() => 'ProtocolException(reason: $reason)';
}

class PairingException implements Exception {
  final String code;
  const PairingException(this.code);

  @override
  String toString() => 'PairingException(code: $code)';
}
