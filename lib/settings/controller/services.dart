import 'package:Dia/settings/model/entities.dart';
import 'package:Dia/shared/services/api_rest_backend.dart';
import 'package:Dia/shared/services/storage.dart';
import 'package:Dia/shared/view/error_handlers.dart';
import 'package:Dia/user_data/model/entities/insulin.dart';
import 'package:timezone/timezone.dart';


typedef SettingChangeListener = void Function();


class SettingsServices {
  final ApiRestBackend _backend = ApiRestBackend();
  final Storage _storage = getLocalStorage();

  static final SettingsServices _instance = SettingsServices._internal();
  factory SettingsServices() {
    return _instance;
  }
  SettingsServices._internal();

  Map<String, List<SettingChangeListener>> _listeners = {};
  Future<List<Category>> getAllSettings() async {
    List<Category> categories = [];
    dynamic response = await _backend.get('/api/v1/settings/');
    for(String categoryKey in response.keys) {
      Category category = Category(key: categoryKey);
      Map<String, dynamic> categorySettings = Map<String, dynamic>.from(response[categoryKey]);
      for (String settingKey in categorySettings.keys) {
        Map<String, dynamic> serializedSetting = Map<String, dynamic>.from(categorySettings[settingKey]);
        Setting setting = Setting.deserialize(settingKey, serializedSetting);
        category.addSetting(setting);
        await _saveSettingInLocalStorage(categoryKey, settingKey, setting.value);
      }
      categories.add(category);
    }
    return categories;
  }

  Future<bool> saveSetting(Category category, Setting setting, String value) async {
    String storedValue = await _retrieveSettingInLocalStorage(category.key, setting.key);
    if (storedValue == value) return false;
    await _backend.post('/api/v1/settings/${category.key}/${setting.key}/', {'value': value});
    setting.value = value;
    await _saveSettingInLocalStorage(category.key, setting.key, setting.value);
    _notifyListeners(category.key, setting.key, value);
    return true;
  }

  void addLanguageChangeListener(SettingChangeListener listener) {
    String category = 'localization';
    String key = 'language';
    String k = '${category}_$key';
    if(!_listeners.containsKey(k)) {
      _listeners[k] = [];
    }
    _listeners[k].add(listener);
  }

  void addTimezoneChangeListener(SettingChangeListener listener) {
    String category = 'localization';
    String key = 'timezone';
    String k = '${category}_$key';
    if(!_listeners.containsKey(k)) {
      _listeners[k] = [];
    }
    _listeners[k].add(listener);
  }

  void _notifyListeners(String category, String key, String value) {
    String k = '${category}_$key';
    List<SettingChangeListener> listeners = _listeners[k];
    if(listeners == null) return;
    for(var listener in listeners) {
      listener();
    }
  }

  Future<List<InsulinType>> getInsulinTypes() async {
    String url = '/api/v1/insulin-types/';
    dynamic contents = await _backend.get(url);
    return List<InsulinType>.from(contents.map((content) => InsulinType.fromJson(content)));
  }

  Future<String> getLanguage() async {
    String lang = await _retrieveSettingInLocalStorage('localization', 'language');
    if(lang == null) {
      await getAllSettings();
      lang = await _retrieveSettingInLocalStorage('localization', 'language');
    }
    return lang;
  }

  Future<Location> getTimezone() async {
    String tzString = await _retrieveSettingInLocalStorage('localization', 'timezone');
    if(tzString == null) {
      await getAllSettings();
      tzString = await _retrieveSettingInLocalStorage('localization', 'timezone');
    }
    Location location = getLocation(tzString);
    return location;
  }

  Future<void> _saveSettingInLocalStorage(String category, String key, String value) async {
    await _storage.set('settings_${category}_$key', value);
  }

  Future<String> _retrieveSettingInLocalStorage(String category, String key) async {
    return await _storage.get('settings_${category}_$key');
  }
}
