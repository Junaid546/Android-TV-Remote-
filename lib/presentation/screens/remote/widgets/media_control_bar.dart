import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/remote_provider.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/remote_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MediaControlBar extends ConsumerWidget {
  const MediaControlBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(
      connectionNotifierProvider.select((s) => s.isConnected),
    );
    final notifier = ref.read(remoteNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RemoteButton(
            icon: const Icon(Icons.skip_previous_rounded),
            style: RemoteButtonStyle.ghost,
            onPressed: isConnected
                ? () => notifier.sendKey('KEYCODE_MEDIA_PREVIOUS')
                : null,
          ),
          RemoteButton(
            icon: const Icon(Icons.fast_rewind_rounded),
            style: RemoteButtonStyle.ghost,
            onPressed: isConnected
                ? () => notifier.sendKey('KEYCODE_MEDIA_REWIND')
                : null,
          ),
          RemoteButton(
            icon: const Icon(Icons.play_arrow_rounded),
            size: 56,
            style: RemoteButtonStyle.normal,
            onPressed: isConnected
                ? () => notifier.sendKey('KEYCODE_MEDIA_PLAY_PAUSE')
                : null,
          ),
          RemoteButton(
            icon: const Icon(Icons.fast_forward_rounded),
            style: RemoteButtonStyle.ghost,
            onPressed: isConnected
                ? () => notifier.sendKey('KEYCODE_MEDIA_FAST_FORWARD')
                : null,
          ),
          RemoteButton(
            icon: const Icon(Icons.skip_next_rounded),
            style: RemoteButtonStyle.ghost,
            onPressed: isConnected
                ? () => notifier.sendKey('KEYCODE_MEDIA_NEXT')
                : null,
          ),
          RemoteButton(
            icon: const Icon(Icons.subtitles_rounded),
            style: RemoteButtonStyle.ghost,
            onPressed: isConnected
                ? () => notifier.sendKey('KEYCODE_CAPTIONS')
                : null,
          ),
        ],
      ),
    );
  }
}
