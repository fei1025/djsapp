import 'package:flutter/material.dart';
import 'package:flutter_demo/background_service.dart';
import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:io';

import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();

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

    super.initState();
    _startCountdown();
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
            ElevatedButton(
              onPressed: startBackgroundService,
              child: const Text("开始"),
            ),
            ElevatedButton(
              onPressed: stopBackgroundService,
              child: const Text("停止"),
            ),
          ],
        ),
      ),
    );
  }
}
