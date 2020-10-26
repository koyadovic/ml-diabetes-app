import 'package:Dia/shared/view/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'main/view/main_screen.dart';
import 'shared/view/theme.dart';


void main() {
  runApp(DiaApp());
}

class DiaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dia',
      theme: ThemeData(
        primarySwatch: DiaTheme.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(title: 'Dia'),
      localizationsDelegates: [
        const TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: translationApp.supportedLocales(),
    );
  }
}
