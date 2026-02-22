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
  @override
  PairingScreenState build() => const PairingScreenState(
    pin: '',
    isSubmitting: false,
    errorMessage: null,
    attemptsLeft: 3,
  );

  void updatePin(String value) {
    if (state.isSubmitting) return;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 6) {
      state = state.copyWith(pin: digits, errorMessage: null);
    }
    if (digits.length == 6) _autoSubmit();
  }

  Future<void> submitPin() async {
    if (state.pin.length != 6 || state.isSubmitting) return;
    state = state.copyWith(isSubmitting: true, errorMessage: null);
    await ref.read(connectionNotifierProvider.notifier).submitPin(state.pin);
    state = state.copyWith(isSubmitting: false);
  }

  void _autoSubmit() {
    HapticService.selection();
    Future.delayed(const Duration(milliseconds: 150), submitPin);
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
}
