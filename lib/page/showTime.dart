import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowTime extends StatelessWidget {
  int selectedMinutes = 0;
  int selectedSeconds = 0;
  Function(String save) success;

  ShowTime({super.key, required this.success});

  _getTime(BuildContext context) {
    int selectedMinutes = 0;
    int selectedSeconds = 0;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 分钟选择
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '分钟:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: selectedMinutes,
                items: List.generate(
                  60,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text(index.toString()),
                  ),
                ),
                onChanged: (value) {
                  selectedMinutes = value!;
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 秒数选择
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '秒:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: selectedSeconds,
                items: List.generate(
                  60,
                  (index) => DropdownMenuItem(
                    value: index,
                    child: Text(index.toString()),
                  ),
                ),
                onChanged: (value) {
                  selectedSeconds = value!;
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          // 显示总秒数
          ElevatedButton(
            onPressed: () {
              final totalSeconds = (selectedMinutes * 60) + selectedSeconds;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('总秒数'),
                  content: Text('用户输入的时间为 $totalSeconds 秒'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('确定'),
                    ),
                  ],
                ),
              );
            },
            child: Text('获取总秒数'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("createTime"),
      content:_getTime(context),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("cancel")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("save")),
      ],
    );
  }
}
