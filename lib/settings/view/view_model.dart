import 'package:Dia/settings/controller/services.dart';
import 'package:Dia/settings/model/entities.dart';
import 'package:Dia/shared/view/error_handlers.dart';
import 'package:Dia/shared/view/messages.dart';
import 'package:Dia/shared/view/view_model.dart';
import 'package:Dia/user_data/model/entities/insulin.dart';
import 'package:easy_localization/easy_localization.dart';
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
    await withBackendErrorHandlersOnView(() async {
      _categories = await settingServices.getAllSettings();
    });
    notifyChanges();
  }

  Future<void> saveSetting(Category category, Setting setting, String value) async {
    await withBackendErrorHandlersOnView(() async {
      bool changed = await settingServices.saveSetting(category, setting, value);
      if (changed) {
        Future.delayed(Duration(milliseconds: 500), () {
          DiaMessages.getInstance().showBriefMessage('Settings saved!'.tr());
        });
      }
    });
  }

  Future<List<InsulinType>> getInsulinTypes() async {
    return await settingServices.getInsulinTypes();
  }

  String getCategoryLabel(Category category) {
    switch(category.key) {
      case 'localization':
        return 'Localization'.tr();
      case 'insulin-types-category':
        return 'Insulin Types'.tr();
      default:
        return 'setting_category_${category.key}'.tr();

    }
  }

  String getSettingLabel(Setting setting) {
    switch(setting.key) {
      case 'timezone':
        return 'Timezone'.tr();
      case 'language':
        return 'Language'.tr();
      case 'insulin-type-1':
        return 'Insulin type No.1'.tr();
      case 'insulin-type-2':
        return 'Insulin type No.2'.tr();
      case 'insulin-type-3':
        return 'Insulin type No.3'.tr();
      default:
        return 'setting_label_${setting.key}'.tr();
    }
  }

}
