import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'db/model/ObjectBoxData.dart';
import 'l10n/l10n.dart';

class MyAppState extends ChangeNotifier {
  static final MyAppState _instance = MyAppState._internal();
  Locale? _locale;

  Locale? get locale => _locale;

  factory MyAppState() {
    return _instance;
  }

  MyAppState._internal(){

  }



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

  int remainingSeconds= 0;

  void setRemainingSeconds(int seconds){
    remainingSeconds=seconds;
    notifyListeners();
  }


  List<TimeData> timeDataList =[];
  void setTimeDataList(List<TimeData> list){
    timeDataList=list;
    notifyListeners();
  }

  void addTimeData(TimeData timeData) {
    timeDataList.add(timeData);
    notifyListeners(); // 触发 UI 更新
  }
}