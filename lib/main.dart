import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/my_app_state.dart';
import 'package:flutter_demo/page/TimerManager.dart';
import 'package:flutter_demo/page/home_page.dart';
import 'package:flutter_demo/service/pedometer_service.dart';
import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:wakelock_plus/wakelock_plus.dart';

import 'init_info.dart';
import 'my_home_widget/home_syc_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'page/my_time.dart';



void main() {
  InitInfo().initializeData();
  runApp(
    ChangeNotifierProvider(
      create: (_) => MyAppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: CountdownPage(),
    );
  }
}

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  int _remainingSeconds = 20; // 5 minutes
  Timer? _timer;
  List<Widget>? pages;
  int _selectedIndex = 0;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    HomeWidget.registerInteractivityCallback(interactiveCallback);
    HomePage homepage= HomePage(() {
      _remainingSeconds=20+1;
      _timer?.cancel();
      _startCountdown();
    });
   // 当前选中的索引
    pages = [
      Center(child:homepage),
      const Center(child: MyTimePage()),
    ];

    // 开启前台服务
   // _startPedometerService();
    // 开始倒计时
    _startCountdown();
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
    //点击某个按钮会进来
    print("uri----------------------:$uri");
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
          MyAppState().setRemainingSeconds(_remainingSeconds);
        });
      } else {
        timer.cancel();
       // _playAlarm();
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
    return Scaffold(
      body: pages![_selectedIndex],
        bottomNavigationBar:BottomNavigationBar(
          currentIndex: _selectedIndex, // 当前选中的索引
          onTap: (index) {
            setState(() {
              _selectedIndex= index;
            });
          },
          items:  [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.timer_outlined),
            label: AppLocalizations.of(context)!.myTime,
          ),
        ],)
    );
  }
}
