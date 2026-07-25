import 'package:flutter/material.dart';
import 'package:plektra/core/di/service_locator.dart';
import 'package:plektra/features/metronome/presentation/pages/metronome_page.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guitar Toolkit',
      home: const MetronomePage(),
    );
  }
}