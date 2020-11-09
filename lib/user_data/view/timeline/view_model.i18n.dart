import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {

  static var _t = Translations("en") +
      {
        "es": "Su nivel de glucosa quedó registrado como %d mg/dL",
        "en": "Your glucose level was registered as %d mg/dL",
      } +
      {
        "es": "",
        "en": "blah"
      };

  String get i18n => localize(this, _t);
  String plural(int value) => localizePlural(value, this, _t);
}
