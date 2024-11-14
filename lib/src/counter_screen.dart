
import 'package:flutter/material.dart';
import 'package:prostate/prostate.dart';

import 'builder/state_builder.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stateManager = StateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị số
            StateBuilder<int>(
              stateKey: 'counter',
              defaultValue: 0,
              builder: (context, value) {
                return Text(
                  '${value ?? 0}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Các nút bấm
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút trừ
                ElevatedButton(
                  onPressed: () {
                    final currentValue = stateManager.getState<int>('counter') ?? 0;
                    stateManager.setState('counter', currentValue - 1);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                // Nút cộng
                ElevatedButton(
                  onPressed: () {
                    final currentValue = stateManager.getState<int>('counter') ?? 0;
                    stateManager.setState('counter', currentValue + 1);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}