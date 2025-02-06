import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/service/pedometer_service.dart';

import 'db/model/ObjectBox.dart';
import 'db/overallModel.dart';

class InitInfo {
  Future<void> initializeData() async {
    WidgetsFlutterBinding.ensureInitialized();
    ObjectBox objectbox = await ObjectBox.create();
    setOB(objectbox);
    PedometerService.instance.init();
  }
}
