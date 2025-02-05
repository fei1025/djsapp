import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/db/model/ObjectBoxData.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/my_app_state.dart';
import 'package:flutter_demo/page/demo.dart';
import 'package:flutter_demo/page/showTime.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
    var appState =context.watch<MyAppState>();
    List<TimeData>  list  = appState.timeDataList;

    return Scaffold(
      appBar: AppBar(title: const Text('My Time'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _createTimerDate();
          },
        )
      ]),
      body: Wrap(
        children: [
          ...list.map((e) => Card(
            elevation: 3.0,
            child: ListTile(
              title: Text(e.titleName??""),
              onTap: () {

              },
            ),
          )),
          Card(
            elevation: 3.0,    // 卡片的阴影
            shadowColor: Colors.white,
            child:AddContent(context),
          ),
        ],
      )
    );
  }

  Widget AddContent(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(15), // 水波纹的圆角
        onTap: () async {
          //WidgetInfo widgetInfo= WidgetInfo(titleName:"新增", dataInfo: []);
          //Navigator.push(context,MaterialPageRoute(builder: (context) => WidgetDataListPage(widgetInfo: widgetInfo,)));
          //context.read<Widget_pageCubit>().getAllData(context);
          addTimeData(context);
        },
        child: Container(
            width: 150,
            height: 0.618 * 150,
            padding: const EdgeInsets.all(10),
            child: const Row(
              children: [
                Icon(Icons.add),
                Text(
                  "新增",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ))
    );
  }
  void addTimeData(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: false);

    // 创建新的 TimeData 实例
    TimeData timeData = TimeData();
    timeData.titleName = "title";

    // 创建新的列表，避免直接修改原列表
    List<TimeData> updatedList = List.from(appState.timeDataList);
    updatedList.add(timeData);

    // 设置新的列表
    appState.setTimeDataList(updatedList);
  }


}
