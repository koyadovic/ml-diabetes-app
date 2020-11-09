import 'package:Dia/shared/view/utils/translations.dart';
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

  String translate(String key) {
    return Translations.of(state.context).translate(key);
  }

}
