import 'package:Dia/settings/controller/services.dart';
import 'package:Dia/settings/model/entities.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:Dia/user_data/model/entities/insulin.dart';
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

  Future<List<InsulinType>> getInsulinTypes() async {
    return await settingServices.getInsulinTypes();
  }

  String getCategoryLabel(Category category) {
    // TODO translations
    switch(category.key) {
      case 'localization':
        return 'Localization';
      case 'insulin-types-category':
        return 'Insulin Types';
    }
    return category.key;
  }

  String getSettingLabel(Setting setting) {
    // TODO translations
    switch(setting.key) {
      case 'timezone':
        return 'Timezone';
      case 'language':
        return 'Language';
      case 'insulin-type-1':
        return 'Insulin type No.1';
      case 'insulin-type-2':
        return 'Insulin type No.2';
      case 'insulin-type-3':
        return 'Insulin type No.3';
    }
    return setting.key;
  }

}
