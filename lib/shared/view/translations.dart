import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;


class _Application {

  static final _Application _application = _Application._internal();

  factory _Application() {
    return _application;
  }

  _Application._internal();

  final List<String> supportedLanguages = ["English", "Spanish"];
  final List<String> supportedLanguagesCodes = ["en", "es"];

  Iterable<Locale> supportedLocales() =>
      supportedLanguagesCodes.map<Locale>((language) => Locale(language, ""));

  LocaleChangeCallback onLocaleChanged;
}


_Application translationApp = _Application();

typedef void LocaleChangeCallback(Locale locale);


class Translations {
  Locale locale;
  static Map<dynamic, dynamic> _translated;
  Translations(Locale locale) {
    this.locale = locale;
    _translated = null;
  }

  static Translations of(BuildContext context) {
    return Localizations.of<Translations>(context, Translations);
  }

  static Future<Translations> load(Locale locale) async {
    Translations translations = Translations(locale);
    String jsonContent =
    await rootBundle.loadString("assets/translations/${locale.languageCode}.json");
    _translated = json.decode(jsonContent);
    return translations;
  }

  get currentLanguage => locale.languageCode;

  String translate(String key) {
    String result = _translated != null && _translated[key] != null && _translated[key] != '' ? _translated[key] : key;
    return result;
  }

}

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  final Locale newLocale;

  const TranslationsDelegate({this.newLocale});

  @override
  bool isSupported(Locale locale) {
    return translationApp.supportedLanguagesCodes.contains(locale.languageCode);
  }

  @override
  Future<Translations> load(Locale locale) {
    return Translations.load(newLocale ?? locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<Translations> old) {
    return true;
  }
}
