import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TimerManager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TimerManager _timerManager = TimerManager(20);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timerManager.startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<int>(
        stream: _timerManager.stream,
        builder: (context, snapshot) {
      if (!snapshot.hasData) return CircularProgressIndicator();
      return Center(
        child: Text('倒计时: ${snapshot.data} 秒', style: TextStyle(fontSize: 24)),
      );
    },
    );
  }
}
