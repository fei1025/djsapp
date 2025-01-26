import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/showTime.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTimePage extends StatefulWidget {
  const MyTimePage({super.key});

  @override
  State<MyTimePage> createState() => _MyTimePageState();
}

class _MyTimePageState extends State<MyTimePage> {

  _addTime(){
    showDialog(context: context, builder:(context){
      return ShowTime(success: (a){
        print(a);
      });
    });
  }
  _createTimerDate() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.createTime),
            content: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                          decoration: InputDecoration(
                        labelText: "title",
                      )),
                      TextButton(onPressed: (){
                        _addTime();
                      }, child: Text("这添加数据"))
                      
                    ],
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
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
