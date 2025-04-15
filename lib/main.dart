import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/db/model/ObjectBox.dart';
import 'package:flutter_demo/db/model/ObjectBoxData.dart';
import 'package:flutter_demo/db/overallModel.dart';
import 'package:flutter_demo/my_app_state.dart';
import 'package:flutter_demo/objectbox.g.dart';
import 'package:flutter_demo/page/TimerManager.dart';
import 'package:flutter_demo/page/demo.dart';
import 'package:flutter_demo/page/home_page.dart';
import 'package:flutter_demo/service/pedometer_service.dart';
import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:wakelock_plus/wakelock_plus.dart';

import 'init_info.dart';
import 'my_home_widget/home_syc_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'page/my_time.dart';

//flutter gen-l10n
void main() async {
  await InitInfo().initializeData();
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

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
    final locale = context.watch<MyAppState>().locale;

    return MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
  int _curRemainingSeconds =0;
  Timer? _timer;
  List<Widget>? pages;
  int _selectedIndex = 0;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    HomeWidget.registerInteractivityCallback(interactiveCallback);

    // 设置 MethodChannel 接收器
    var channel = const MethodChannel('com.example.flutterplu_demo/widget_click');
    channel.setMethodCallHandler(_handleMethodCall);
    TimeData timeData = objectbox.timeDataBox .query(TimeData_.izDefault.equals("0")) .build() .findFirst() ??TimeData(remainingSeconds: 20);
     _remainingSeconds = timeData.remainingSeconds!;
     _curRemainingSeconds=_remainingSeconds;
    HomePage homepage = HomePage(() {
      _remainingSeconds = _curRemainingSeconds ;
      print("_remainingSeconds${_remainingSeconds}");
      _timer?.cancel();
      _startCountdown();
    });
    // 当前选中的索引
    pages = [
      Center(child: homepage),
      const Center(child: MyTimePage()),
      //const Center(child: CustomCupertinoTimerPicker()),
    ];
    // 开启前台服务
     _startPedometerService();
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
      // showDialog(
      //   context: context,
      //   builder: (buildContext) => AlertDialog(
      //     title: const Text('App started from HomeScreenWidget'),
      //     content: Text('Here is the URI: $uri'),
      //   ),
      // );
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
    WakelockPlus.enable();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
          MyAppState().setRemainingSeconds(_remainingSeconds);
        });
      } else {
        timer.cancel();
         _playAlarm();
         WakelockPlus.disable();
      }
    });
  }

  void _playAlarm() {
    FlutterRingtonePlayer().playAlarm();
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // 当前选中的索引
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
             BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.timer_outlined),
              label: AppLocalizations.of(context)!.myTime,
            ),
            // BottomNavigationBarItem(
            //   icon: const Icon(Icons.timer_outlined),
            //   label: AppLocalizations.of(context)!.myTime,
            // ),
          ],
        ));
  }

  // 处理从 MethodChannel 接收的消息
  Future<void> _handleMethodCall(MethodCall call) async {
    print("收到 MethodChannel 消息: ${call.method}");
    if (call.method == 'widgetClicked') {
      final Map<Object?, Object?> args = call.arguments;
      final String host = args['host'] as String;
      final Map<Object?, Object?> params =
          args['params'] as Map<Object?, Object?>;


      if (host == 'button') {
        final buttonId = params['id'];
        final buttonTitle = params['title'];
        final buttonId1 = int.tryParse(buttonId.toString());
        TimeData timeData = objectbox.timeDataBox .query(TimeData_.id.equals(buttonId1!)) .build() .findFirst()!;
        _remainingSeconds = timeData.remainingSeconds!;
        _curRemainingSeconds=_remainingSeconds;
        _timer?.cancel();
        _startCountdown();
      }
    }
  }
}
