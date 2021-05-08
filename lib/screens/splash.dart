import 'dart:async';

import 'package:Aaraam/screens/welcome/welcome.dart';
import 'package:Aaraam/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Splash();
  }

  Future<Timer> Splash() async {
    return Timer(Duration(seconds: 3), onDoneLoading);
  }

  void onDoneLoading() {
    final is_login = getStringValuesSF('IS_LOGIN');

    /* Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Welcome();
        },
      ),
    );*/
    if (is_login == 'AARAAM') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          ModalRoute.withName("/dashboard"));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Welcome();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFAED581),
                      Color(0xFF9CCC65),
                      Color(0xFF8BC34A),
                      Color(0xFF7CB342),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 130.0),
                      _buildSocialBtnRow(),
                      Text(
                        'Aaraam',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Ghar bethe samaan deliver.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 20.0,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildLogo(
            AssetImage(
              'assets/images/delivery_3.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(AssetImage logo) {
    return GestureDetector(
      child: Container(
        height: 180.0,
        width: 180.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }
}
