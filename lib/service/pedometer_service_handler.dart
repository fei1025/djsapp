import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_foreground_task/flutter_foreground_task.dart';


@pragma('vm:entry-point')
void startPedometerService() {
  FlutterForegroundTask.setTaskHandler(PedometerServiceHandler());
}

class PedometerServiceHandler extends TaskHandler {


  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {

  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // not use
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {

  }

  void onNotificationButtonPressed(String id) {
    dev.log("这是测试id啊 啊: $id");
    dev.log("这是测试id啊啊啊: $id");
  }


}
