import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/service/pedometer_service.dart';
import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:home_widget/home_widget.dart';
import 'dart:io';

import 'package:wakelock_plus/wakelock_plus.dart';

import 'my_home_widget/home_syc_widget.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PedometerService.instance.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CountdownPage(),
    );
  }
}

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  int _remainingSeconds = 300; // 5 minutes
  Timer? _timer;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    HomeWidget.registerInteractivityCallback(interactiveCallback);

    // 开启前台服务
    _startPedometerService();
    // 开始倒计时
    //_startCountdown();
    super.initState();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkForWidgetLaunch();
    HomeWidget.widgetClicked.listen(_launchedFromWidget);
  }
  void _checkForWidgetLaunch() {
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }
  void _launchedFromWidget(Uri? uri) {
    if (uri != null) {
      showDialog(
        context: context,
        builder: (buildContext) => AlertDialog(
          title: const Text('App started from HomeScreenWidget'),
          content: Text('Here is the URI: $uri'),
        ),
      );
    }
  }


  void _startPedometerService() async {
    try {
      // already started
      if (await PedometerService.instance.isRunningService) {
        return;
      }

      PedometerService.instance.start();
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  void _startCountdown() {
    //WakelockPlus.enable();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _playAlarm();
       // WakelockPlus.disable();

      }
    });
  }

  void _playAlarm() {
    FlutterRingtonePlayer().playAlarm();
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
  void dispose() {
    _timer?.cancel();
    FlutterRingtonePlayer().stop();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text("5分钟倒计时")),
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
              child: const Text("停止音乐并退出"),
            ),
          ],
        ),
      ),
    );
  }
}
