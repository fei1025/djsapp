import 'package:objectbox/objectbox.dart';

@Entity()
class SystemSettings{
  @Id()
  int id=0;
  // 是否开机默认启动计时器
  String? startTime="0";

  SystemSettings({this.startTime});
}