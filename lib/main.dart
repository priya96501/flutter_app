import 'package:flutter/material.dart';
import 'package:Aaraam/screens/splash.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My App",
      home: Scaffold(
          body: SplashScreen()),
    );
  }
}
