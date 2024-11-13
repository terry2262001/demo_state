class Observable<T> {
  T _value;
  final List<void Function(T)> _listeners = [];

  Observable(this._value);
  T get value => _value;
  set value(T newValue) {
    if (value != newValue) {
      _value = newValue;
          _notifyListener();
    }
  }

  void addListener(void Function(T) listener) {
    _listeners.add(listener);
  }
  void removeListener(void Function(T) listener) {
    _listeners.remove(listener);
  }
  void _notifyListener() {
    for (var listener in _listeners) {
      listener(_value);
    }
  }
}