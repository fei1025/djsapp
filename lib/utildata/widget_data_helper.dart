import 'dart:convert';
import 'package:flutter_demo/db/overallModel.dart';
import 'package:home_widget/home_widget.dart';

final List<Map<String, dynamic>> buttonList = [];

Future<void> loadAndUpdateWidgetData() async {
  buttonList.clear();
  objectbox.timeDataBox .getAll().forEach((action) {
    buttonList.add({"title":action.titleName,"id":action.id});
  });
  final jsonData = jsonEncode(buttonList);
  await HomeWidget.saveWidgetData<String>('button_list', jsonData);
  await HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider');
}