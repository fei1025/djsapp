import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/my_app_state.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {


  VoidCallback reloadTime;

   HomePage(this.reloadTime);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //TimerManager _timerManager = TimerManager(20);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final List<Map<String, dynamic>> buttonList = [
    {"title": "按钮1", "id": 101},
    {"title": "按钮2", "id": 102},
    {"title": "按钮3", "id": 103},
    {"title": "按钮4", "id": 104},
    {"title": "按钮5", "id": 105},
    {"title": "按钮6", "id": 106},
    {"title": "按钮7", "id": 107},
  ];

  Future<void> updateWidget() async {
    // 将对象数组转换为 JSON 字符串
    final jsonData = jsonEncode(buttonList);

    // 保存数据并更新小组件
    await HomeWidget.saveWidgetData<String>('button_list', jsonData);
    await HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider');
    //HomeWidget.updateWidget(qualifiedAndroidName:'es.antonborri.home_widget_example.glance.HomeWidgetReceiver', );
  }
  @override
  Widget build(BuildContext context) {
    final myAppState = Provider.of<MyAppState>(context);
    final minutes =(myAppState.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds =(myAppState.remainingSeconds % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(title: const Text(""),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.restart_alt_outlined),
              onPressed: () {
                widget.reloadTime();
              },
            )
          ]
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$minutes:$seconds",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateWidget,
                child: const Text('更新小组件数据'),
              )

            ],
          ),
        ),
    )
    ;
  }
}
