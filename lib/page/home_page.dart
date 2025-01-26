import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/my_app_state.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  VoidCallback reloadTime;

   HomePage(this.reloadTime);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //TimerManager _timerManager = TimerManager(20);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final myAppState = Provider.of<MyAppState>(context);
    final minutes =(myAppState.remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds =(myAppState.remainingSeconds % 60).toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(title: const Text(""),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.restart_alt_outlined),
              onPressed: () {
                widget.reloadTime();
              },
            )
          ]
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$minutes:$seconds",
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

            ],
          ),
        ),
    )
    ;
  }
}
