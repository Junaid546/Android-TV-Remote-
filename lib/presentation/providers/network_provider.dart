import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

@riverpod
Stream<bool> wifiStatus(Ref ref) {
  final datasource = ref.watch(networkNativeDataSourceProvider);
  return datasource.wifiStatusStream.distinct();
}

@riverpod
class NetworkNotifier extends _$NetworkNotifier {
  @override
  bool build() => true;

  void updateStatus(bool connected) => state = connected;
}
