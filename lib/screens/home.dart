import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String appTitle = 'Firebase messaging';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: appTitle,
        home: MainPage(appTitle: appTitle),
      );
}

class MainPage extends StatelessWidget {
  final String appTitle;

  const MainPage({required this.appTitle});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
//  body: MessagingWidget(),
      );
}
