sealed class RemoteSessionStatus {
  const RemoteSessionStatus();
}

final class RemoteSessionDisconnected extends RemoteSessionStatus {
  const RemoteSessionDisconnected();
}

final class RemoteSessionConnecting extends RemoteSessionStatus {
  final String deviceIp;

  const RemoteSessionConnecting(this.deviceIp);
}

final class RemoteSessionConnected extends RemoteSessionStatus {
  final String deviceIp;
  final String deviceName;

  const RemoteSessionConnected(this.deviceIp, this.deviceName);
}

final class RemoteSessionReconnecting extends RemoteSessionStatus {
  final String deviceIp;
  final int attempt;
  final int maxAttempts;

  const RemoteSessionReconnecting(
    this.deviceIp,
    this.attempt,
    this.maxAttempts,
  );
}

final class RemoteSessionFailed extends RemoteSessionStatus {
  final String deviceIp;
  final String reason;

  const RemoteSessionFailed(this.deviceIp, this.reason);
}
