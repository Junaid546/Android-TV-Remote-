import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:atv_remote/data/models/settings_model.dart';
import 'package:atv_remote/presentation/providers/adb_provider.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/settings_provider.dart';
import 'package:atv_remote/presentation/screens/apps/tv_apps.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppsScreen extends ConsumerStatefulWidget {
  const AppsScreen({super.key});

  @override
  ConsumerState<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends ConsumerState<AppsScreen> {
  late final TextEditingController _hostController;
  late final TextEditingController _connectPortController;
  late final TextEditingController _pairPortController;
  late final TextEditingController _pairCodeController;
  String? _hostError;
  String? _pairPortError;
  String? _pairCodeError;
  String? _connectPortError;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController();
    _connectPortController = TextEditingController(text: '5555');
    _pairPortController = TextEditingController();
    _pairCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _connectPortController.dispose();
    _pairPortController.dispose();
    _pairCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);
    final adbState = ref.watch(adbNotifierProvider);
    final connection = ref.watch(connectionNotifierProvider);
    final connectedTv = connection.device;

    if (_hostController.text.isEmpty) {
      _hostController.text = settings.adbHost ?? connectedTv?.ipAddress ?? '';
    }
    if (_pairPortController.text.isEmpty && settings.adbPairPort > 0) {
      _pairPortController.text = settings.adbPairPort.toString();
    }
    if (_connectPortController.text.isEmpty) {
      _connectPortController.text = settings.adbConnectPort.toString();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Apps',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Text(
                      adbState.isConnected ? 'ADB Ready' : 'ADB Not Connected',
                      style: TextStyle(
                        color: adbState.isConnected
                            ? AppColors.success
                            : AppColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                children: [
                  _buildConnectionContextCard(connectedTv?.name),
                  const SizedBox(height: 14),
                  _buildAdbSetupCard(context, settings, adbState),
                  const SizedBox(height: 16),
                  Text(
                    'Quick Launch',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    itemCount: tvApps.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.18,
                        ),
                    itemBuilder: (context, index) {
                      final app = tvApps[index];
                      final packageName =
                          settings.appPackageOverrides[app.id] ??
                          app.packageName;
                      return _AppTile(
                        app: app,
                        packageName: packageName,
                        adbConnected: adbState.isConnected,
                        onTap: () => _onAppTileTap(context, app, packageName),
                        onEdit: () =>
                            _editPackageOverride(context, app, packageName),
                      );
                    },
                  ),
                ],
              ),
            ),
            const BottomNavBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionContextCard(String? deviceName) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.tv_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              deviceName == null
                  ? 'No TV connected'
                  : 'Connected TV: $deviceName',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdbSetupCard(
    BuildContext context,
    SettingsModel settings,
    AdbState adbState,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Wireless Debugging Setup',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _hostController,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('TV IP / Host', errorText: _hostError),
            onChanged: (_) {
              if (_hostError != null) {
                setState(() => _hostError = null);
              }
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _pairPortController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    'Pair Port',
                    errorText: _pairPortError,
                  ),
                  onChanged: (_) {
                    if (_pairPortError != null) {
                      setState(() => _pairPortError = null);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _pairCodeController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    'Pair Code',
                    errorText: _pairCodeError,
                  ),
                  onChanged: (_) {
                    if (_pairCodeError != null) {
                      setState(() => _pairCodeError = null);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _connectPortController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration(
              'Connect Port',
              errorText: _connectPortError,
            ),
            onChanged: (_) {
              if (_connectPortError != null) {
                setState(() => _connectPortError = null);
              }
            },
          ),
          const SizedBox(height: 12),
          if (adbState.reason != null && adbState.reason!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                adbState.reason!,
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: adbState.isBusy ? null : _pairAdb,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text('Pair'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: adbState.isBusy ? null : _connectAdb,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.85),
                  ),
                  child: const Text('Connect'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: _disconnectAdb,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.muted,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: const Text('Disconnect'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? errorText}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
      errorText: errorText,
      filled: true,
      fillColor: AppColors.background,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }

  Future<void> _pairAdb() async {
    final host = _hostController.text.trim();
    final pairPort = _parsePort(_pairPortController.text.trim());
    final pairingCode = _pairCodeController.text.trim();

    _clearAdbFieldErrors();
    final hostError = _validateHost(host);
    final pairPortError = _validatePort(pairPort);
    final pairingCodeError = _validatePairingCode(pairingCode);
    if (hostError != null ||
        pairPortError != null ||
        pairingCodeError != null) {
      setState(() {
        _hostError = hostError;
        _pairPortError = pairPortError;
        _pairCodeError = pairingCodeError;
      });
      _showMessage('Fix ADB pairing fields and try again', isError: true);
      return;
    }

    try {
      await ref
          .read(adbNotifierProvider.notifier)
          .pair(host: host, port: pairPort!, pairingCode: pairingCode);
      _showMessage('ADB paired successfully');
    } catch (e) {
      _showMessage(_formatAdbError(e), isError: true);
    }
  }

  Future<void> _connectAdb() async {
    final host = _hostController.text.trim();
    final connectPort = _parsePort(_connectPortController.text.trim());
    final pairPort = _parsePort(_pairPortController.text.trim()) ?? 0;

    _clearAdbFieldErrors();
    final hostError = _validateHost(host);
    final connectPortError = _validatePort(connectPort);
    if (hostError != null || connectPortError != null) {
      setState(() {
        _hostError = hostError;
        _connectPortError = connectPortError;
      });
      _showMessage('Fix ADB connection fields and try again', isError: true);
      return;
    }

    try {
      await ref
          .read(adbNotifierProvider.notifier)
          .connect(host: host, port: connectPort!);
      await ref
          .read(settingsNotifierProvider.notifier)
          .saveAdbConfig(
            host: host,
            connectPort: connectPort,
            pairPort: pairPort,
          );
      _showMessage('ADB connected');
    } catch (e) {
      _showMessage(_formatAdbError(e), isError: true);
    }
  }

  Future<void> _disconnectAdb() async {
    await ref.read(adbNotifierProvider.notifier).disconnect();
    _showMessage('ADB disconnected');
  }

  Future<void> _launchApp(TvAppDefinition app, String packageName) async {
    try {
      final result = await ref
          .read(adbNotifierProvider.notifier)
          .launchApp(
            packageName: packageName,
            activityName: app.activityName,
            playStoreFallback: true,
          );

      final openedPlayStore = result['openedPlayStore'] == true;
      if (openedPlayStore) {
        _showMessage('${app.name} not installed. Opened Play Store listing.');
      } else {
        _showMessage('Opened ${app.name}');
      }
    } catch (e) {
      _showMessage(_formatAdbError(e), isError: true);
    }
  }

  Future<void> _onAppTileTap(
    BuildContext context,
    TvAppDefinition app,
    String packageName,
  ) async {
    final adbState = ref.read(adbNotifierProvider);
    if (!adbState.isConnected) {
      final settings = ref.read(settingsNotifierProvider);
      final connectedTvIp = ref
          .read(connectionNotifierProvider)
          .device
          ?.ipAddress;
      final connected = await _showAdbConnectGuidance(
        context,
        settings: settings,
        connectedTvIp: connectedTvIp,
      );
      if (!connected) return;
    }

    if (!mounted) return;
    await _launchApp(app, packageName);
  }

  Future<bool> _showAdbConnectGuidance(
    BuildContext context, {
    required SettingsModel settings,
    required String? connectedTvIp,
  }) async {
    final host = _resolveAdbHost(
      settings: settings,
      connectedTvIp: connectedTvIp,
    );
    final connectPort = _resolveConnectPort(settings);
    if (host != null && _hostController.text.trim() != host) {
      _hostController.text = host;
    }
    if (_connectPortController.text.trim() != connectPort.toString()) {
      _connectPortController.text = connectPort.toString();
    }

    String? inlineError;
    var busy = false;

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                18,
                20,
                MediaQuery.viewInsetsOf(context).bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Connect ADB To Launch Apps',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Wireless Debugging must be enabled on the TV.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. TV Settings > Developer options > Wireless debugging',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '2. Connect using host ${host ?? '(missing)'} and port $connectPort',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontSize: 12,
                    ),
                  ),
                  if (inlineError != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      inlineError!,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: busy
                              ? null
                              : () => Navigator.pop(sheetContext, false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.muted,
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton(
                          onPressed: busy
                              ? null
                              : () async {
                                  final resolvedHost = host?.trim() ?? '';
                                  final hostError = _validateHost(resolvedHost);
                                  final portError = _validatePort(connectPort);
                                  if (hostError != null || portError != null) {
                                    setSheetState(() {
                                      inlineError = hostError ?? portError;
                                    });
                                    return;
                                  }

                                  setSheetState(() {
                                    busy = true;
                                    inlineError = null;
                                  });

                                  try {
                                    await ref
                                        .read(adbNotifierProvider.notifier)
                                        .connect(
                                          host: resolvedHost,
                                          port: connectPort,
                                        );
                                    await ref
                                        .read(settingsNotifierProvider.notifier)
                                        .saveAdbConfig(
                                          host: resolvedHost,
                                          connectPort: connectPort,
                                          pairPort:
                                              _parsePort(
                                                _pairPortController.text.trim(),
                                              ) ??
                                              settings.adbPairPort,
                                        );
                                    if (sheetContext.mounted) {
                                      Navigator.pop(sheetContext, true);
                                    }
                                  } catch (e) {
                                    setSheetState(() {
                                      busy = false;
                                      inlineError = _formatAdbError(e);
                                    });
                                  }
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: busy
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : const Text('Connect ADB'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    return result ?? false;
  }

  Future<void> _editPackageOverride(
    BuildContext context,
    TvAppDefinition app,
    String current,
  ) async {
    final controller = TextEditingController(text: current);

    final value = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text('Package for ${app.name}'),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration('Package name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (value != null) {
      await ref
          .read(settingsNotifierProvider.notifier)
          .setAppPackageOverride(app.id, value);
      if (mounted) setState(() {});
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.surfaceElevated,
      ),
    );
  }

  void _clearAdbFieldErrors() {
    if (_hostError == null &&
        _pairPortError == null &&
        _pairCodeError == null &&
        _connectPortError == null) {
      return;
    }
    setState(() {
      _hostError = null;
      _pairPortError = null;
      _pairCodeError = null;
      _connectPortError = null;
    });
  }

  int? _parsePort(String value) => int.tryParse(value);

  String? _validateHost(String host) {
    if (host.isEmpty) return 'Host is required';
    final ipv4 = RegExp(
      r'^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$',
    );
    final hostname = RegExp(r'^[a-zA-Z0-9.-]+$');
    if (ipv4.hasMatch(host) || hostname.hasMatch(host)) return null;
    return 'Enter a valid IP or hostname';
  }

  String? _validatePort(int? port) {
    if (port == null) return 'Port is required';
    if (port < 1 || port > 65535) return 'Use range 1-65535';
    return null;
  }

  String? _validatePairingCode(String code) {
    if (code.isEmpty) return 'Pair code is required';
    if (!RegExp(r'^\d{6}$').hasMatch(code)) return 'Use 6 digits';
    return null;
  }

  String _formatAdbError(Object error) {
    if (error is NativeChannelException) {
      return error.message;
    }
    return error.toString();
  }

  String? _resolveAdbHost({
    required SettingsModel settings,
    required String? connectedTvIp,
  }) {
    final fromConnectedTv = connectedTvIp?.trim() ?? '';
    if (fromConnectedTv.isNotEmpty) return fromConnectedTv;

    final fromSettings = settings.adbHost?.trim() ?? '';
    if (fromSettings.isNotEmpty) return fromSettings;

    final fromInput = _hostController.text.trim();
    if (fromInput.isNotEmpty) return fromInput;
    return null;
  }

  int _resolveConnectPort(SettingsModel settings) {
    final fromInput = _parsePort(_connectPortController.text.trim());
    if (_validatePort(fromInput) == null && fromInput != null) {
      return fromInput;
    }

    if (_validatePort(settings.adbConnectPort) == null) {
      return settings.adbConnectPort;
    }

    return 5555;
  }
}

class _AppTile extends StatelessWidget {
  const _AppTile({
    required this.app,
    required this.packageName,
    required this.adbConnected,
    required this.onTap,
    required this.onEdit,
  });

  final TvAppDefinition app;
  final String packageName;
  final bool adbConnected;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      onLongPress: onEdit,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: app.brandColor.withValues(alpha: 0.28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: app.brandColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(app.icon, color: app.brandColor),
              ),
              const Spacer(),
              Text(
                app.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                packageName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 11,
                  height: 1.2,
                ),
              ),
              if (!adbConnected) ...[
                const SizedBox(height: 6),
                Text(
                  'Tap to connect ADB',
                  style: TextStyle(
                    color: AppColors.warning.withValues(alpha: 0.9),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
