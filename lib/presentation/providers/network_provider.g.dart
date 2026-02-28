// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wifiStatusHash() => r'33c79e2ebc7cb963e1980137732d623af755ecdd';

/// See also [wifiStatus].
@ProviderFor(wifiStatus)
final wifiStatusProvider = AutoDisposeStreamProvider<bool>.internal(
  wifiStatus,
  name: r'wifiStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wifiStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WifiStatusRef = AutoDisposeStreamProviderRef<bool>;
String _$networkNotifierHash() => r'd7b17fe389a830164869a7a224ba94c2c0834e6c';

/// See also [NetworkNotifier].
@ProviderFor(NetworkNotifier)
final networkNotifierProvider =
    AutoDisposeNotifierProvider<NetworkNotifier, bool>.internal(
      NetworkNotifier.new,
      name: r'networkNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$networkNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NetworkNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
