import 'package:flutter/material.dart';

@pragma("vm:entry-point")
Future<void> interactiveCallback(Uri? data) async {

  print("------------------------------------------------------------------");
  print("data11111111111111111?.host:${data?.host}");

  // if (data?.host == 'titleclicked') {
  //   final greetings = [
  //     'Hello',
  //     'Hallo',
  //     'Bonjour',
  //     'Hola',
  //     'Ciao',
  //     '哈洛',
  //     '안녕하세요',
  //     'xin chào',
  //   ];
  //   final selectedGreeting = greetings[Random().nextInt(greetings.length)];
  //   await HomeWidget.setAppGroupId('YOUR_GROUP_ID');
  //   await HomeWidget.saveWidgetData<String>('title', selectedGreeting);
  //   await HomeWidget.updateWidget(
  //     name: 'HomeWidgetExampleProvider',
  //     iOSName: 'HomeWidgetExample',
  //   );
  //   if (Platform.isAndroid) {
  //     await HomeWidget.updateWidget(
  //       qualifiedAndroidName:
  //       'es.antonborri.home_widget_example.glance.HomeWidgetReceiver',
  //     );
  //   }
  // }
}

