import 'package:flutter/material.dart';

class DiaViewModel {
  List<Function> _listeners = [];

  final State state;

  DiaViewModel(this.state);

  void addOnChangeListener(Function listener) {
    int i = _listeners.indexOf(listener);
    if(i == -1) _listeners.add(listener);
  }

  void notifyChanges() {
    for(Function function in _listeners) {
      function();
    }
  }

}
