import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShowTime extends StatefulWidget {
  final Function(int save) success;
  int? time;

  ShowTime({Key? key, required this.success,this.time}) : super(key: key);

  @override
  _ShowTimeState createState() =>_ShowTimeState();
}

class _ShowTimeState
    extends State<ShowTime> {
  Duration _date = const Duration(seconds: 0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.time!=null){
      _date=Duration(seconds: widget.time!);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.3, // 宽度为屏幕的 80%
        child: Column(
          mainAxisSize: MainAxisSize.min, // 高度自适应内容
          children: <Widget>[
            buildPicker(CupertinoTimerPickerMode.hms),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(), // 返回按钮
                  child:  Text(AppLocalizations.of(context)!.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(_date.inSeconds<=0){
                      showSnackBar(context);
                      return;
                    }
                    widget.success(_date.inSeconds);
                    Navigator.of(context).pop(); // 确认并返回选中的时间
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void showSnackBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('时间不能小于等于0'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );

  }

  Widget buildPicker(CupertinoTimerPickerMode mode) {
    return SizedBox(
      height: 200, // 限制高度
      child: CupertinoTimerPicker(
        mode: mode,
        initialTimerDuration: _date,
        onTimerDurationChanged: (date) {
          setState(() => _date = date);
        },
      ),
    );
  }
}
