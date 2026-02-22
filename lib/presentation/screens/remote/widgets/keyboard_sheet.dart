import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/remote_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeyboardSheet extends ConsumerStatefulWidget {
  const KeyboardSheet({super.key});

  @override
  ConsumerState<KeyboardSheet> createState() => _KeyboardSheetState();
}

class _KeyboardSheetState extends ConsumerState<KeyboardSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text;
    if (text.isEmpty) return;

    // Send ENTER or the text string if local logic allows.
    // For now, we follow the spec "sendKey('KEYCODE_ENTER')" or per character.
    // Assuming simple key-by-key for generic ATV support or ENTER to submit.
    ref.read(remoteNotifierProvider.notifier).sendKey('KEYCODE_ENTER');
    _controller.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: const TextStyle(color: AppColors.onBackground),
                  decoration: InputDecoration(
                    hintText: 'Type text here...',
                    hintStyle: TextStyle(
                      color: AppColors.muted.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  onSubmitted: (_) => _handleSubmit(),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _handleSubmit,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
