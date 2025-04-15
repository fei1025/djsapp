import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../l10n/l10n.dart'; // for defaultTargetPlatform

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  /// 初始化使用系统语言
  void setInitialLocale(Locale deviceLocale) {
    if (L10n.all.contains(deviceLocale)) {
      _locale = deviceLocale;
    } else {
      _locale = const Locale('en'); // fallback
    }
  }

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
