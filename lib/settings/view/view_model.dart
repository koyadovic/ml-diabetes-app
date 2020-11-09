import 'package:Dia/settings/controller/services.dart';
import 'package:Dia/settings/model/entities.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:flutter/src/widgets/framework.dart';


class SettingsViewModel extends DiaViewModel {
  final SettingsServices settingServices = SettingsServices();
  List<Category> _categories;

  SettingsViewModel(State<StatefulWidget> state) : super(state);

  List<Category> get categories {
    if(_categories == null) {
      _refreshSettings();
      return [];
    }
    return _categories;
  }

  Future<void> _refreshSettings() async {
    _categories = await settingServices.getAllSettings();
    notifyChanges();
  }

  Future<void> saveSetting(Category category, Setting setting, String value) async {
    await settingServices.saveSetting(category, setting, value);
  }

  String getCategoryLabel(Category category) {
    // TODO
    return category.key;
  }

  String getSettingLabel(Setting setting) {
    // TODO
    return setting.key;
  }

}
