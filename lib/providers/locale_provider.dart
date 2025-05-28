import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('fr');
    } else if (_locale.languageCode == 'fr') {
      _locale = const Locale('ar');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }
}
