import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/db/model/ObjectBoxData.dart';
import 'package:flutter_demo/db/overallModel.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/my_app_state.dart';
import 'package:flutter_demo/page/demo.dart';
import 'package:flutter_demo/page/showTime.dart';
import 'package:flutter_demo/utildata/widget_data_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MyTimePage extends StatefulWidget {
  const MyTimePage({super.key});

  @override
  State<MyTimePage> createState() => _MyTimePageState();
}

class _MyTimePageState extends State<MyTimePage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // 使用 addPostFrameCallback 将操作推迟到框架完成当前构建后执行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      List<TimeData> timeDataList = [];
      _getBox().getAll().forEach((action) {
        timeDataList.add(action);
      });
      context.read<MyAppState>().setTimeDataList(timeDataList);
    });
  }

  loadList() {
    List<TimeData> timeDataList = [];
    _getBox().getAll().forEach((action) {
      timeDataList.add(action);
    });
    context.read<MyAppState>().setTimeDataList(timeDataList);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _getBox().getAll().then((value) {
    //   context.read<MyAppState>().setTimeDataList(value);
    // });
  }

  _getBox() {
    return objectbox.timeDataBox;
  }

  _createTimerDate() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _timeController = TextEditingController();
    final TextEditingController _titleController = TextEditingController();
    TimeData timeData = TimeData();

    int? time1 = null;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.createTime),
            content: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.title,
                        ),
                        onSaved: (value) {
                          // 保存输入的值
                          timeData.titleName = value;
                        },
                        validator: (String? value) {
                          if (value == null || value == '') {
                            return AppLocalizations.of(context)!.pleaseEnterTitle;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _timeController,
                        onTap: () async {
                          // 弹出对话框
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return ShowTime(
                                  time: time1,
                                  success: (time) {
                                    setState(() {
                                      time1 = time;
                                      final hours = (time ~/ 3600)
                                          .toString()
                                          .padLeft(2, '0'); // 计算小时
                                      final minutes = ((time % 3600) ~/ 60)
                                          .toString()
                                          .padLeft(2, '0'); // 计算分钟
                                      final seconds = (time % 60)
                                          .toString()
                                          .padLeft(2, '0'); // 计算秒
                                      _timeController.text =
                                          "$hours:$minutes:$seconds"; // 更新到输入框
                                      timeData.remainingSeconds = time;
                                    });
                                  });
                            },
                          );
                        },
                        readOnly: true,
                        // 设置为只读
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.time,
                        ),
                        validator: (String? value) {
                          if (timeData.remainingSeconds == null ||
                              timeData.remainingSeconds == 0) {
                            return AppLocalizations.of(context)!.pleaseSelectValidTimeNotZero;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.cancel)),
              TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      addTimeData(context, timeData);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save)),
            ],
          );
        });
  }

  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<TimeData> list = appState.timeDataList;

    return Scaffold(
        appBar: AppBar(
          title:  Text(AppLocalizations.of(context)!.myTime),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert),  // 三个点图标
              onSelected: (String value) {
                // 根据选择的值切换语言
                if (value == 'English') {
                  context.read<MyAppState>().setLocale(const Locale('en'));
                } else if (value == '中文') {
                  context.read<MyAppState>().setLocale(const Locale('zh'));
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'English',
                    child: Text('English'),
                  ),
                  PopupMenuItem<String>(
                    value: '中文',
                    child: Text('中文'),
                  ),
                ];
              },
            ),

          ],
        ),

        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            String timeText = "";
            if (list[index].remainingSeconds != null) {
              int time = list[index].remainingSeconds!;
              final hours = (time ~/ 3600).toString().padLeft(2, '0'); // 计算小时
              final minutes =
                  ((time % 3600) ~/ 60).toString().padLeft(2, '0'); // 计算分钟
              final seconds = (time % 60).toString().padLeft(2, '0'); // 计算秒
              timeText = "$hours:$minutes:$seconds"; // 更新到输入框
            }
            TimeData data = list[index];
            return Card(
              elevation: 3.0,
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("${AppLocalizations.of(context)!.title}: "),
                                Text(list[index].titleName.toString()),
                              ],
                            ),
                            TextButton(
                                onPressed: () {
                                  deleteTimeData(context, data);
                                },
                                child: Text(AppLocalizations.of(context)!.delete))
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${AppLocalizations.of(context)!.time}: "),
                            Text(timeText),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text("${AppLocalizations.of(context)!.setDefault}: ",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 8), //
                            Switch(
                              value: data.izDefault == "0" ? true : false,
                              activeColor: Colors.green,
                              // 选中时的颜色
                              inactiveThumbColor: Colors.grey,
                              // 未选中时的按钮颜色
                              inactiveTrackColor: Colors.grey[300],
                              // 未选中时的轨道颜色
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  if (isSwitched) {
                                    data.izDefault = "0";
                                  } else {
                                    data.izDefault = "1";
                                  }
                                  setdefault(context, data);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  // 处理点击事件
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Navigator.push(context,MaterialPageRoute(builder: (context) => DemoPage()));
            //addTimeData(context);
            _createTimerDate();
          },
          child: const Icon(Icons.add),
        ));
  }

  void addTimeData(BuildContext context, TimeData timeData) {
    var appState = Provider.of<MyAppState>(context, listen: false);
    // 创建新的列表，避免直接修改原列表
    List<TimeData> updatedList = List.from(appState.timeDataList);
    updatedList.add(timeData);
    // 设置新的列表
    appState.setTimeDataList(updatedList);
    _getBox().put(timeData);
    loadAndUpdateWidgetData();
  }

  void setdefault(BuildContext context, TimeData timeData) {
    var appState = Provider.of<MyAppState>(context, listen: false);
    //
    // // 创建新的列表，避免直接修改原列表
    // List<TimeData> updatedList = List.from(appState.timeDataList);
    // updatedList.add(timeData);
    // // 全部设置为非默认
    // updatedList.forEach((element) {
    //   element.izDefault="1";
    // });

    //数据全部更新
    //_getBox().putMany(updatedList);
    _getBox().put(timeData);
    //加载新的数据
    loadList();
  }

  void deleteTimeData(BuildContext context, TimeData timeData) {
    var appState = Provider.of<MyAppState>(context, listen: false);
    // 创建新的列表，避免直接修改原列表
    List<TimeData> updatedList = List.from(appState.timeDataList);
    updatedList.remove(timeData);

    // 设置新的列表
    appState.setTimeDataList(updatedList);
    _getBox().remove(timeData.id);
  }
}
