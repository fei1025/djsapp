import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/db/overallModel.dart';
import 'package:flutter_demo/my_app_state.dart';
import 'package:flutter_demo/utildata/widget_data_helper.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../db/model/ObjectBoxData.dart';

class HomePage extends StatefulWidget {


  VoidCallback reloadTime;

   HomePage(this.reloadTime);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> buttonList = [];

  //TimerManager _timerManager = TimerManager(20);
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {

      initData();
    });
    super.initState();
  }

  void initData(){
    //loadTime();
    //updateWidget();

    loadAndUpdateWidgetData();
  }

  void loadTime(){

  }

  Future<void> updateWidget() async {
    // 将对象数组转换为 JSON 字符串
    final jsonData = jsonEncode(buttonList);

    // 保存数据并更新小组件
    await HomeWidget.saveWidgetData<String>('button_list', jsonData);
    await HomeWidget.updateWidget(name: 'HomeWidgetExampleProvider');
    //HomeWidget.updateWidget(qualifiedAndroidName:'es.antonborri.home_widget_example.glance.HomeWidgetReceiver', );
  }

  void _stopAlarmAndExit() {
    FlutterRingtonePlayer().stop();
    if (Platform.isAndroid) {
      exit(0);
    } else if (Platform.isIOS) {
      exit(0);
    }
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
                onPressed: _stopAlarmAndExit,
                child:  Text(AppLocalizations.of(context)!.stopAndExit),
              )

            ],
          ),
        ),
    )
    ;
  }
}
