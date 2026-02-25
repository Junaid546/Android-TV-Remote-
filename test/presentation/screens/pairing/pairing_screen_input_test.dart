import 'package:atv_remote/presentation/screens/pairing/pairing_screen_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _PinInputHarness extends ConsumerWidget {
  const _PinInputHarness();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pairingScreenNotifierProvider);

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            TextField(
              key: const Key('pin_input'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
              ],
              onChanged: (value) {
                ref
                    .read(pairingScreenNotifierProvider.notifier)
                    .updatePin(value);
              },
            ),
            ElevatedButton(
              key: const Key('confirm_button'),
              onPressed: state.pin.length == 6 && !state.isSubmitting
                  ? () {}
                  : null,
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('accepts only hex chars and normalizes to uppercase', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _PinInputHarness(),
      ),
    );

    await tester.enterText(find.byKey(const Key('pin_input')), '12g-3b*');
    await tester.pump();

    final state = container.read(pairingScreenNotifierProvider);
    expect(state.pin, '123B');
  });

  testWidgets('confirm button is enabled only when 6 valid hex chars exist', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const _PinInputHarness(),
      ),
    );

    ElevatedButton button = tester.widget(
      find.byKey(const Key('confirm_button')),
    );
    expect(button.onPressed, isNull);

    await tester.enterText(find.byKey(const Key('pin_input')), '12AB');
    await tester.pump();
    button = tester.widget(find.byKey(const Key('confirm_button')));
    expect(button.onPressed, isNull);

    container
        .read(pairingScreenNotifierProvider.notifier)
        .state = const PairingScreenState(
      pin: '12AB3F',
      isSubmitting: false,
      errorMessage: null,
      attemptsLeft: 3,
    );
    await tester.pump();

    button = tester.widget(find.byKey(const Key('confirm_button')));
    expect(button.onPressed, isNotNull);
  });
}
