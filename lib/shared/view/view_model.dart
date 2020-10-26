import 'package:Dia/shared/view/translations.dart';
import 'package:flutter/material.dart';

import 'messages.dart';
import 'navigation.dart';

class DiaViewModel {
  bool _loading = false;

  final State state;
  final Navigation navigation;
  final Messages messages;

  DiaViewModel(this.state, this.navigation, this.messages);

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
