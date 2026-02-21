// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$discoveryNotifierHash() => r'027f6970db0da46e47af39eed92ab9e720347061';

/// See also [DiscoveryNotifier].
@ProviderFor(DiscoveryNotifier)
final discoveryNotifierProvider =
    NotifierProvider<DiscoveryNotifier, AsyncValue<List<TvDevice>>>.internal(
  DiscoveryNotifier.new,
  name: r'discoveryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$discoveryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DiscoveryNotifier = Notifier<AsyncValue<List<TvDevice>>>;
String _$discoveryErrorHash() => r'90e6cf09887a3a2084d3f9399b25830529a936cb';

/// See also [DiscoveryError].
@ProviderFor(DiscoveryError)
final discoveryErrorProvider =
    AutoDisposeNotifierProvider<DiscoveryError, Failure?>.internal(
  DiscoveryError.new,
  name: r'discoveryErrorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$discoveryErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DiscoveryError = AutoDisposeNotifier<Failure?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
