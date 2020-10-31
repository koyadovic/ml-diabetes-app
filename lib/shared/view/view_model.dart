import 'package:Dia/shared/model/api_rest_backend.dart';
import 'package:Dia/shared/view/utils/messages.dart';
import 'package:Dia/shared/view/utils/translations.dart';
import 'package:flutter/material.dart';

import 'utils/navigation.dart';

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

  Future<void> withGeneralErrorHandlers(Function function) async {
    try {
      await function();
    } on NotLoggedIn catch (err) {
      DiaNavigation.getInstance().requestScreenChange(DiaScreen.LOGIN);
    } on BackendUnavailable catch (err) {
      DiaMessages.getInstance().showInformation('Dia Services are unavailable. Try again later.');
    }
  }
}
