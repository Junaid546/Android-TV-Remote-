import 'package:atv_remote/core/errors/failures.dart';

extension FailureToMessage on Failure {
  String get userMessage => switch (this) {
    NetworkFailure(:final message) => message,
    WifiDisabledFailure() => 'Please connect to a WiFi network',
    PermissionDeniedFailure() => 'Network permission required',
    DeviceUnreachableFailure(:final ip) => 'Cannot reach device at $ip',
    ConnectionTimeoutFailure(:final host) => 'Connection to $host timed out',
    PairingFailure(:final reason) => 'Pairing failed: $reason',
    PinExpiredFailure() => 'PIN has expired. Please try again.',
    WrongPinFailure(:final attemptsLeft) =>
      'Wrong PIN. $attemptsLeft attempts left.',
    CommandFailure(:final command) => 'Failed to send $command command',
    StorageFailure(:final reason) => 'Storage error: $reason',
    UnknownFailure(:final message) => 'Something went wrong: $message',
  };

  bool get isRetryable => switch (this) {
    ConnectionTimeoutFailure() => true,
    DeviceUnreachableFailure() => true,
    NetworkFailure() => true,
    _ => false,
  };
}
