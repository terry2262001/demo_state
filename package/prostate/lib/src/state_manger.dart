import 'package:flutter/widgets.dart';
import 'package:prostate/src/observable.dart';

class StateManager {
  final Map<String, Observable<dynamic>> _states = {};

  T getState<T>(String key, {T? defaultValue}) {
    if (!_states.containsKey(key)){
      if (defaultValue == null) {
        throw FlutterError("No default value provided for key: $key");
      }
      _states[key] = Observable<T>(defaultValue);
    }
    return _states[key]?.value as T;
  }
  void setState<T>(String key, T value) {
    if (_states.containsKey(key)) {
      _states[key]?.value = value;
    }
  }
  void resetState(String key) {
    if (_states.containsKey(key)) {
      _states.remove(key);
    }
  }
  void clearAllState() {
    _states.clear();
  }
}