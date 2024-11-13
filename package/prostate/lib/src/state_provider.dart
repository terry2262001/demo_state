
import 'package:flutter/widgets.dart';
import 'package:prostate/src/state_manger.dart';

class StateProvider extends InheritedWidget{
  final StateManager stateManager;

  const StateProvider({
    super.key,
    required super.child,
    required this.stateManager,
});

  static StateManager of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<StateProvider>();
    if (provider == null) throw FlutterError("StateProvider can't found context");
    return provider.stateManager;
  }


  @override
  bool updateShouldNotify(StateProvider oldWidget) {
    return stateManager != oldWidget.stateManager;
  }

}