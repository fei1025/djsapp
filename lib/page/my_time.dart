import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/demo.dart';
import 'package:flutter_demo/page/showTime.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTimePage extends StatefulWidget {
  const MyTimePage({super.key});

  @override
  State<MyTimePage> createState() => _MyTimePageState();
}

class _MyTimePageState extends State<MyTimePage> {

  _createTimerDate() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _timeController = TextEditingController();
     int? time1 = null;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.createTime),
            content: SizedBox(
              height: 200,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            decoration: InputDecoration(
                          labelText: "title",
                        )),
                        TextFormField(
                          controller: _timeController,
                          onTap: () async {
                            // 弹出对话框
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return ShowTime(time:time1,success: (time) {
                                  setState(() {
                                    time1=time;
                                    final hours = (time ~/ 3600).toString().padLeft(2, '0'); // 计算小时
                                    final minutes = ((time % 3600) ~/ 60).toString().padLeft(2, '0'); // 计算分钟
                                    final seconds = (time % 60).toString().padLeft(2, '0'); // 计算秒
                                    _timeController.text = "$hours:$minutes:$seconds"; // 更新到输入框
                                  });
                                });
                              },
                            );

                          },
                          readOnly: true, // 设置为只读
                          decoration: InputDecoration(
                            labelText: "Time",
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      _formKey.currentState!.save();
                    }
                    Navigator.of(context).pop();
                  },

                  child: Text(AppLocalizations.of(context)!.cancel)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.save)),
            ],
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Time'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _createTimerDate();
          },
        )
      ]),
      body: Center(
        child: Text("time"),
      ),
    );
  }
}
