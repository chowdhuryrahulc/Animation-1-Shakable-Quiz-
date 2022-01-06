// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

bool switchValue1 = false;
bool switchValue2 = false;
bool switchValue3 = false;
bool switchValue4 = false;

class _QuizState extends State<Quiz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.width / 1.7,
                              horizontal: 20),
                          child: Scaffold(
                            appBar: AppBar(
                              leading: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.close)),
                            ),
                            body: SizedBox(
                              // height: 50,
                              child: Column(
                                children: [
                                  dialogListTile(
                                      'Reversed review', switchValue1),
                                  dialogListTile(
                                      'Reveal random side', switchValue2),
                                  dialogListTile(
                                      'Show only image', switchValue3),
                                  dialogListTile(
                                      'Auto read cards', switchValue4)
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: Icon(Icons.settings))
          ],
        ),
        backgroundColor: Colors.blue,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 350,
                color: Colors.white,
                margin: EdgeInsets.all(7.0),
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

  ListTile dialogListTile(String title, bool switchValue) {
    return ListTile(
      leading: Text(title),
      trailing: Switch(
          value: switchValue,
          onChanged: (switchValue) {
            setState(() {
              switchValue = !switchValue;
            });
          }),
    );
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
  bool visible = false;
  Color containerColor = Colors.white;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 7.0)
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
            // margin: EdgeInsets.symmetric(horizontal: 7.0),
            margin: EdgeInsets.only(
                left: offsetAnimation.value + 7.0,
                right: 7.0 - offsetAnimation.value,
                bottom: 7.0),
            child: Column(
              children: [
                Container(
                  height: 50,
                  color: containerColor,
                  child: Center(
                    child: GestureDetector(
                        onTap: () {
                          controller!.forward(from: 0.0);
                          visible = true;
                          containerColor = Colors.red;
                        },
                        child: Text(widget.textInput)),
                  ),
                ),
                Visibility(
                    visible: visible,
                    child: Container(
                      color: containerColor,
                      height: 50,
                    ))
              ],
            ),
          );
        });
  }
}
