import 'package:flutter/material.dart';


class DiaViewModel {
  bool _loading = false;

  final State state;

  DiaViewModel(this.state);

  void notifyChanges() {
    if(this.state.mounted)
      this.state.setState(() {});
  }

  bool isLoading() {
    return _loading;
  }

  Future<void> setLoading(bool loading) async {
    _loading = loading;
    notifyChanges();
  }

}
