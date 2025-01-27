import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCupertinoTimerPicker extends StatefulWidget {
  const CustomCupertinoTimerPicker({Key? key}) : super(key: key);

  @override
  _CustomCupertinoTimerPickerState createState() =>
      _CustomCupertinoTimerPickerState();
}

class _CustomCupertinoTimerPickerState
    extends State<CustomCupertinoTimerPicker> {
  Duration _date = const Duration(seconds: 30);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.8, // 宽度为屏幕的 80%
        child: Column(
          mainAxisSize: MainAxisSize.min, // 高度自适应内容
          children: <Widget>[
            Text(
              '当前时间: ${_date.toString()}',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildInfoTitle('选择时间'),
            const SizedBox(height: 8),
            buildPicker(CupertinoTimerPickerMode.hms),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(), // 返回按钮
                  child: const Text('返回'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(_date); // 确认并返回选中的时间
                  },
                  child: const Text('确认'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTitle(String info) {
    return Text(
      info,
      style: const TextStyle(
          color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
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
