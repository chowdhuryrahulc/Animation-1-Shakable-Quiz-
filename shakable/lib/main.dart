// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shakable/quiz.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Quiz(),
    );
  }
}

class TestAnimWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TestAnimWidgetState();
}

class _TestAnimWidgetState extends State<TestAnimWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  AnimationController? controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller!.reverse();
        }
      });
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
                animation: offsetAnimation,
                builder: (buildContext, child) {
                  // if (offsetAnimation.value < 0.0)
                  //   print('${offsetAnimation.value + 8.0}');
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.0),
                    padding: EdgeInsets.only(
                        left: offsetAnimation.value + 24.0,
                        right: 24.0 - offsetAnimation.value),
                    child: Center(
                        child: TextField(
                      controller: textController,
                    )),
                  );
                }),
            ElevatedButton(
              onPressed: () {
                controller!.forward(from: 0.0);
              },
              child: Text('Enter'),
            )
          ],
        ));
  }
}
