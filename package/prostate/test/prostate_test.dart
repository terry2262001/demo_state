import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prostate/src/state_manger.dart';

void main() {
  test('StateManager should manage state correctly', () {
    final stateManager = StateManager();

    // Test setting and getting state
    stateManager.setState<int>('counter', 0);
    expect(stateManager.getState<int>('counter'), 0);

    stateManager.setState<int>('counter', 5);
    expect(stateManager.getState<int>('counter'), 5);

    // Test resetting state
    stateManager.resetState('counter');
    expect(() => stateManager.getState<int>('counter', defaultValue: null), throwsA(isA<FlutterError>()));
  });

  test('StateManager should handle default values correctly', () {
    final stateManager = StateManager();

    // Get state with default value
    final defaultValue = stateManager.getState<int>('counter', defaultValue: 10);
    expect(defaultValue, 10);

    // Update state after default
    stateManager.setState<int>('counter', 20);
    expect(stateManager.getState<int>('counter'), 20);
  });

  test('StateManager should clear all states', () {
    final stateManager = StateManager();

    stateManager.setState<int>('counter', 5);
    stateManager.setState<String>('name', 'Test');

    stateManager.clearAllState();

    expect(() => stateManager.getState<int>('counter', defaultValue: null), throwsA(isA<FlutterError>()));
    expect(() => stateManager.getState<String>('name', defaultValue: null), throwsA(isA<FlutterError>()));
  });
}

