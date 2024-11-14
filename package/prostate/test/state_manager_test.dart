import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prostate/prostate.dart';

void main() {

    test('Should return existing state value', () {
      final stateManager = StateManager();
      stateManager.setState<int>('counter', 5);
      expect(stateManager.getState<int>('counter'), 5);
    });

    test('Should return defaultValue for unknown state', () {
      final stateManager = StateManager();
      final counter = stateManager.getState<int>('counter', defaultValue: 10);
      expect(counter, 10);
    });

    test('Should return null for unknown state without defaultValue', () {
      final stateManager = StateManager();
      expect(stateManager.getState<int?>('counter'), null);
    });

    test('Should throw error for type mismatch', () {
      final stateManager = StateManager();
      stateManager.setState<String>('counter', "hello");
      expect(() => stateManager.getState<int>('counter'),  throwsA(isA<FlutterError>()));
    });

    test('Should allow null as a valid value', () {
      final stateManager = StateManager();
      stateManager.setState<int?>('counter', null);
      expect(stateManager.getState<int?>('counter'), null);
    });

    test('Should reset state correctly', () {
      final stateManager = StateManager();
      stateManager.setState<int>('counter', 10);
      stateManager.resetState('counter');
      expect(stateManager.getState<int?>('counter'), null);
    });

    test('Should initialize with defaultValue and update correctly', () {
      final stateManager = StateManager();
      final initialValue = stateManager.getState<int>('counter', defaultValue: 0);
      expect(initialValue, 0);

      stateManager.setState<int>('counter', 20);
      expect(stateManager.getState<int>('counter'), 20);
    });
  }

