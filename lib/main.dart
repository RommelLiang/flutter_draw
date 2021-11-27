import 'dart:async';

import 'package:flutter/material.dart';

import 'board.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Draw Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  Timer timer;
  int value = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
       setState(() {
         value++;
         if(value >=10){
           value = 0;
         }
       });
     });
   });

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var hours = DateTime.now().hour % 12;
    var minutes = DateTime.now().minute;
    var seconds = DateTime.now().second;
    return Scaffold(
      appBar: new AppBar(
        title: new Text('$hours:$minutes:$seconds:${DateTime.now().millisecond}'),
      ),
      body: CustomPaint(
        painter: KarlPainter(value*0.1),
        size: MediaQuery.of(context).size,
      ),
    );
  }
}
