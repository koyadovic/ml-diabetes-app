import 'package:Dia/shared/view/screens.dart';
import 'package:flutter/material.dart';

class DiaViewModel {
  List<Function> _listeners = [];
  bool _loading = false;

  final State state;
  final Function(DiaScreen) requestScreenChange;

  DiaViewModel(this.state, this.requestScreenChange);

  void addOnChangeListener(Function listener) {
    int i = _listeners.indexOf(listener);
    if(i == -1) _listeners.add(listener);
  }

  void notifyChanges() {
    for(Function function in _listeners) {
      function();
    }
  }

  bool isLoading() {
    return _loading;
  }

  void setLoading(bool loading) {
    _loading = loading;
    notifyChanges();
  }
}
