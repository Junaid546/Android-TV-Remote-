import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class NetworkFailure extends Failure {
  final String message;
  const NetworkFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class WifiDisabledFailure extends Failure {
  const WifiDisabledFailure();
}

class PermissionDeniedFailure extends Failure {
  final String permission;
  const PermissionDeniedFailure(this.permission);

  @override
  List<Object?> get props => [permission];
}

class DeviceUnreachableFailure extends Failure {
  final String ip;
  final int port;
  const DeviceUnreachableFailure(this.ip, this.port);

  @override
  List<Object?> get props => [ip, port];
}

class ConnectionTimeoutFailure extends Failure {
  final String host;
  const ConnectionTimeoutFailure(this.host);

  @override
  List<Object?> get props => [host];
}

class PairingFailure extends Failure {
  final String reason;
  const PairingFailure(this.reason);

  @override
  List<Object?> get props => [reason];
}

class PinExpiredFailure extends Failure {
  const PinExpiredFailure();
}

class WrongPinFailure extends Failure {
  final int attemptsLeft;
  const WrongPinFailure(this.attemptsLeft);

  @override
  List<Object?> get props => [attemptsLeft];
}

class CommandFailure extends Failure {
  final String command;
  final String reason;
  const CommandFailure(this.command, this.reason);

  @override
  List<Object?> get props => [command, reason];
}

class StorageFailure extends Failure {
  final String reason;
  const StorageFailure(this.reason);

  @override
  List<Object?> get props => [reason];
}

class UnknownFailure extends Failure {
  final String message;
  final StackTrace? stackTrace;
  const UnknownFailure(this.message, [this.stackTrace]);

  @override
  List<Object?> get props => [message, stackTrace];
}
