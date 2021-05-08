import 'dart:async';

import 'package:Aaraam/screens/dashboard.dart';
import 'package:Aaraam/utilities/confirm_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConfirmWidget();
}

class _ConfirmWidget extends State<Confirm> {
  @override
  void initState() {
    super.initState();
    Done();
  }

  Future<Timer> Done() async {
    return Timer(Duration(seconds: 3), onDoneLoading);
  }

  void onDoneLoading() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard()
        ),
        ModalRoute.withName("/dashboard")
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConfirmBody(),
    );
  }
}
