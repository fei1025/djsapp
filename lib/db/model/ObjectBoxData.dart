import 'package:objectbox/objectbox.dart';

@Entity()
class TimeData{
  @Id()
  int id=0;
  String? titleName;
  //倒计时数据 以秒为单位
  int? remainingSeconds;
  // 创建时间
  @Property(type: PropertyType.date) // Store as int in milliseconds
  DateTime? createdDate;

  int? nextId;
  String? type;
  //备注说明
  String? remake;
  // 0是默认 1:不是默认
  String? izDefault;
  TimeData({this.titleName,this.remainingSeconds,this.createdDate,this.nextId,this.type,this.remake,this.izDefault});
}