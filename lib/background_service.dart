import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}
const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
const notificationId = 888;

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke("stop");
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();



  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: false,
      autoStartOnBoot: true,
      foregroundServiceTypes:[AndroidForegroundType.dataSync],
      notificationChannelId: notificationChannelId, // this must match with notification channel you created above.
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: notificationId,

    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print("什么时候运行的");
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
  if (service is AndroidServiceInstance) {
    service.setForegroundNotificationInfo(
      title: "倒计时计时器",
      content: "在后台运行",
    );
    service.setAsForegroundService();
  }



  // // bring to foreground
  // Timer.periodic(const Duration(seconds: 1), (timer) async {
  //   if (service is AndroidServiceInstance) {
  //     if (await service.isForegroundService()) {
  //       flutterLocalNotificationsPlugin.show(
  //         notificationId,
  //         'COOL SERVICE',
  //         'Awesome ${DateTime.now()}',
  //         const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             notificationChannelId,
  //             'MY FOREGROUND SERVICE',
  //             icon: 'ic_bg_service_small',
  //             ongoing: true,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // });
}