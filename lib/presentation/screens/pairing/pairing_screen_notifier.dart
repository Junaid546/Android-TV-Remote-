import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/core/utils/failure_mapper.dart';
import 'package:atv_remote/core/utils/haptic_service.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pairing_screen_notifier.freezed.dart';
part 'pairing_screen_notifier.g.dart';

@freezed
class PairingScreenState with _$PairingScreenState {
  const factory PairingScreenState({
    required String pin,
    required bool isSubmitting,
    String? errorMessage,
    required int attemptsLeft,
  }) = _PairingScreenState;
}

@riverpod
class PairingScreenNotifier extends _$PairingScreenNotifier {
  static final RegExp _hexPinPattern = RegExp(r'^[0-9A-F]{0,6}$');
  bool _disposed = false;

  @override
  PairingScreenState build() {
    ref.onDispose(() => _disposed = true);
    return const PairingScreenState(
      pin: '',
      isSubmitting: false,
      errorMessage: null,
      attemptsLeft: 3,
    );
  }

  void updatePin(String value) {
    if (state.isSubmitting) return;

    final chars = value.trim().toUpperCase();
    if (!_hexPinPattern.hasMatch(chars)) return;
    state = state.copyWith(pin: chars, errorMessage: null);
    if (chars.length == 6) _autoSubmit();
  }

  Future<void> submitPin() async {
    if (_disposed) return;
    if (state.pin.length != 6 || state.isSubmitting) return;
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    await ref.read(connectionNotifierProvider.notifier).submitPin(state.pin);
    if (_disposed) return;
    state = state.copyWith(isSubmitting: false);
  }

  void _autoSubmit() {
    HapticService.selection();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_disposed) return;
      submitPin();
    });
  }

  void handleError(Failure failure) {
    state = state.copyWith(
      isSubmitting: false,
      pin: '', // clear pin for re-entry
      errorMessage: failure.userMessage,
      attemptsLeft: failure is WrongPinFailure
          ? failure.attemptsLeft
          : state.attemptsLeft,
    );
    HapticService.error();
  }

  void prepareForRetry() {
    state = state.copyWith(
      pin: '',
      isSubmitting: false,
      errorMessage: null,
      attemptsLeft: 3,
    );
  }
}
