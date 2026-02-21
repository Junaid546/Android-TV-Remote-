// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$remoteNotifierHash() => r'5b7015e3034018cdac04d2d1e04b3eae6ce8229c';

/// See also [RemoteNotifier].
@ProviderFor(RemoteNotifier)
final remoteNotifierProvider = NotifierProvider<RemoteNotifier, bool>.internal(
  RemoteNotifier.new,
  name: r'remoteNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RemoteNotifier = Notifier<bool>;
String _$remoteErrorHash() => r'8c57d21a07143cf474ea6d758ae8f303405a21f1';

/// See also [RemoteError].
@ProviderFor(RemoteError)
final remoteErrorProvider =
    AutoDisposeNotifierProvider<RemoteError, Failure?>.internal(
  RemoteError.new,
  name: r'remoteErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$remoteErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RemoteError = AutoDisposeNotifier<Failure?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
