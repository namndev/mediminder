import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:mediminder/common.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(milliseconds: 3200),
      () {
        context.popUntilWithName("/");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.white,
      child: Center(
        child: Center(
            child: FlareActor(
              "assets/animations/Success Check.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "Untitled",
            ),
          ),
      ),
    );
  }
}
