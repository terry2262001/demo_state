import 'package:demo_state/src/screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:prostate/prostate.dart';


void main() {
  final stateManager = StateManager();

  runApp(
    StateProvider(
      stateManager: stateManager,
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: ProductsScreen(),
    );
  }
}