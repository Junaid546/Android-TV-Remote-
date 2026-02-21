import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atv_remote/app/app.dart';
import 'package:atv_remote/app/bootstrap.dart';

void main() async {
  final container = await bootstrap();
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
