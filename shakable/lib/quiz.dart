// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
        ),
        backgroundColor: Colors.blue,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                color: Colors.white,
                margin: EdgeInsets.all(6.0),
                child: Center(
                  child: Text('Terminator'),
                ),
              ),
              OptionWidget('Option 1'),
              OptionWidget('Option 2'),
              OptionWidget('Option 3'),
              OptionWidget('Option 4'),
            ],
          ),
        ));
  }
}

class OptionWidget extends StatefulWidget {
  final String textInput;
  const OptionWidget(
    this.textInput, {
    Key? key,
  }) : super(key: key);

  @override
  State<OptionWidget> createState() => _OptionWidgetState();
}

class _OptionWidgetState extends State<OptionWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        // Tween (short of inBetween) animates between begin and end.
        .chain(CurveTween(curve: Curves.elasticIn))
        // ignore: todo
        //TODO WHAT IS CHAIN & double ?
        // CurveTween || ColorTween
        //  Curves give animation.
        // Curvs helps control speed of animation.
        // Curve is the shakeAnimation
        // Curves can also be used in AnimatedFOO's (Container etc.)
        .animate(controller!)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller!.reverse();
          // Bcoz finally we want the curve (Container) to return to original position
        }
      });
    return AnimatedBuilder(
        animation: offsetAnimation,
        builder: (buildContext, child) {
          // child is the thing that doesnt animate.
          return Container(
            // margin: EdgeInsets.fromLTRB(6, 6, 6, 0),
            //! PROBLEM SOLVED:- shake Animation needs space given in end of Tween to shake.
            margin: EdgeInsets.symmetric(horizontal: 24.0),
            padding: EdgeInsets.only(
                left: offsetAnimation.value + 24.0,
                right: 24.0 - offsetAnimation.value),
            color: Colors.white,
            height: 50,
            child: Center(
              child: GestureDetector(
                  onTap: () {
                    controller!.forward(from: 0.0);
                  },
                  child: Text(widget.textInput)),
            ),
          );
        });
  }
}
