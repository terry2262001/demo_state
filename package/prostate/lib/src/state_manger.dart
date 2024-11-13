import 'package:prostate/src/observable.dart';

class StateManager {
  final Map<String, Observable<dynamic>> _states = {};

  T getState<T>(String key, {T? defaultValue}) {
    if (!_states.containsKey(key)){
      _states[key] = Observable<T>(defaultValue as T);
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