class Category {
  final String key;
  final List<Setting> settings = [];

  Category({this.key});

  void addSetting(Setting setting) => settings.add(setting);
}


class SettingSpecification {
  final bool required;
  final List<Map<String, dynamic>> options;

  SettingSpecification({this.required, this.options});

}

class Setting {
  final String key;
  final String value;
  final SettingSpecification specification;

  Setting({this.key, this.value, this.specification});

  static Setting deserialize(String settingKey, Map<String, dynamic> serializedSetting) {
    return Setting(
        key: settingKey,
        value: serializedSetting['value'],
        specification: SettingSpecification(
          required: serializedSetting['spec']['required'],
          options: List<Map<String, dynamic>>.from(serializedSetting['spec']['options']),
        )
    );
  }

}
