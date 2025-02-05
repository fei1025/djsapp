import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'db/model/ObjectBoxData.dart';

class MyAppState extends ChangeNotifier {
  static final MyAppState _instance = MyAppState._internal();
  factory MyAppState() {
    return _instance;
  }

  MyAppState._internal(){

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