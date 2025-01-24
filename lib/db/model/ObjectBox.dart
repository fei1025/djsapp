
import 'package:flutter_demo/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;

import 'ObjectBoxData.dart';
//dart run build_runner build 更新数据后运行这个命令
class ObjectBox {
  /// The Store of this app.
  late final Store store;
  late final Box<TimeData> timeDataBox;


  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
    timeDataBox=Box<TimeData>(store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    //final store = await openStore(directory: p.join(docsDir.path, "obx-djs"));
    final store = await openStore(directory:"memory:obx-djs");
    return ObjectBox._create(store);
  }
}