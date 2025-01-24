import 'package:flutter/cupertino.dart';
import 'package:flutter_demo/service/pedometer_service.dart';

import 'db/model/ObjectBox.dart';
import 'db/overallModel.dart';

class InitInfo {
  void initializeData() async {
    ObjectBox objectbox = await ObjectBox.create();
    setOB(objectbox);
    WidgetsFlutterBinding.ensureInitialized();
    PedometerService.instance.init();
  }
}
